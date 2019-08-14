module View.Abilities exposing (render, render2)

import Dict exposing (Dict)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Maybe.Extra

import Action.Abilities as Abilities
import Action.Ancestry as Ancestry
import Action.Background as Background
import Action.Class as Class
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.View as View
import Fun
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data
import UI.Button
import UI.ChooseOne
import UI.ChooseMany
import UI.Text


render : State -> Element Msg
render state =
    El.column
        [ El.spacing 10 ]
        [ UI.Text.header1 "Abilities"
        , renderBaseAbilities state
        , renderAncestry state
        , renderBackground state
        , renderClass state
        , renderFree state 1
        , renderTotal state 1
        ]


render2 : State -> Int -> Element Msg
render2 state level =
    El.column
        [ El.spacing 10 ]
        [ renderFree state level
        , renderTotal state level
        ]


renderBaseAbilities : State -> Element Msg
renderBaseAbilities state =
    El.column
        box
        [ UI.Text.header2 "Base Abilities"
        , UI.ChooseOne.render
            { all = [ "Standard", "Rolled" ]
            , available = [ "Standard", "Rolled" ]
            , selected =
                case state.character.baseAbilities of
                    Ability.Standard ->
                        Just "Standard"
                    Ability.Rolled _ ->
                        Just "Rolled"
            , onChange = Msg.Abilities << Abilities.SetBaseAbilities
            , toString = identity
            }
        , case state.character.baseAbilities of
            Ability.Standard ->
                El.none
            Ability.Rolled abilities ->
                renderRolledAbilities abilities
        ]


renderRolledAbilities : Ability.Abilities -> Element Msg
renderRolledAbilities abilities =
    El.column
        box
        [ UI.Text.header3 "Rolled Abilities"
        , El.table
            []
            { data =
                List.map
                    (pairRolledInputs abilities)
                    [ (Ability.Str, Ability.Int)
                    , (Ability.Dex, Ability.Wis)
                    , (Ability.Con, Ability.Cha)
                    ]
            , columns =
                [ { header = El.none
                  , width = El.shrink
                  , view = \row -> row.label1
                  }
                , { header = El.none
                  , width = El.px 50
                  , view = \row -> row.input1
                  }
                , { header = El.none
                  , width = El.shrink
                  , view = \row -> row.label2
                  }
                , { header = El.none
                  , width = El.px 50
                  , view = \row -> row.input2
                  }
                ]
            }
        ]


-- pairAbilityInputs : (Ability, Ability) -> a
pairRolledInputs abilities (ability1, ability2) =
    { label1 =
        El.el
            [ El.centerY
            , El.paddingXY 5 0
            ]
            <| El.text <| Ability.toString ability1
    , input1 =
        Input.text
            []
            { onChange = Msg.Abilities << Abilities.SetBaseAbility abilities ability1
            , text =
                case Ability.abilityValue ability1 abilities of
                    0 -> ""
                    value -> String.fromInt value
            , placeholder = Nothing
            , label = Input.labelHidden <| Ability.toString ability1
            }
    , label2 =
        El.el
            [ El.centerY
            , El.paddingXY 5 0
            ]
            <| El.text <| Ability.toString ability2
    , input2 =
        Input.text
            []
            { onChange = Msg.Abilities << Abilities.SetBaseAbility abilities ability2
            , text =
                case Ability.abilityValue ability2 abilities of
                    0 -> ""
                    value -> String.fromInt value
            , placeholder = Nothing
            , label = Input.labelHidden <| Ability.toString ability2
            }
    }


renderAncestry : State -> Element Msg
renderAncestry state =
    El.column
        box
        [ UI.Text.header2 "Ancestry"
        , case state.character.ancestry of
            Nothing ->
                UI.Button.render
                    { onPress = Just <| Msg.OpenModal View.Ancestry
                    , label = El.text "Select an Ancestry first"
                    }
            Just ancestry ->
                El.column
                    [ El.spacing 10
                    , El.width El.fill
                    ]
                    [ UI.Button.render
                        { onPress = Just <| Msg.OpenModal View.Ancestry
                        , label = El.text ancestry.name
                        }
                    , Input.checkbox
                        []
                        { onChange = Msg.Ancestry << Ancestry.SetVoluntaryFlaw
                        , icon = Input.defaultCheckbox
                        , checked = state.character.ancestryOptions.voluntaryFlaw
                        , label =
                            Input.labelRight
                                []
                                <| El.text "Voluntary Flaw"
                        }
                    , El.column
                        box
                        <| List.concat
                            [ [ UI.Text.header3 "Ability Boosts" ]
                            , List.indexedMap (renderAncestryMod ancestry state.character Boost)
                                <| Character.ancestryAbilityBoosts state.character
                            ]
                    , if List.isEmpty (Character.ancestryAbilityFlaws state.character) then
                        El.none
                      else
                        El.column
                            box
                            <| List.concat
                                [ [ UI.Text.header3 "Ability Flaws" ]
                                , List.indexedMap (renderAncestryMod ancestry state.character Flaw)
                                    <| Character.ancestryAbilityFlaws state.character
                                ]
                    ]
        ]


type AbilityModType
    = Boost
    | Flaw


renderAncestryMod : Data.Ancestry -> Character -> AbilityModType -> Int -> Ability.AbilityMod -> Element Msg
renderAncestryMod ancestry character modType index mod =
    case mod of
        Ability.Fixed ability ->
            El.text <| Ability.toString ability
        Ability.Choice list ->
            UI.ChooseOne.render
                { all = list
                , selected =
                    character.ancestryOptions
                        |> optionField modType True
                        |> Dict.get index
                , available =
                    validAncestryChoices
                        (fixedAbilities <| optionField modType True <| ancestry)
                        (fixedAbilities <| optionField modType False <| ancestry)
                        (character.ancestryOptions
                            |> optionField modType True
                            |> Dict.remove index
                            |> Dict.values
                        )
                        (character.ancestryOptions
                            |> optionField modType False
                            |> Dict.values
                        )
                        list
                , onChange =
                    case modType of
                        Boost ->
                            Msg.Ancestry << Ancestry.SetAbilityBoost index
                        Flaw ->
                            Msg.Ancestry << Ancestry.SetAbilityFlaw index
                , toString = Ability.toString
                }


{-| Valid ancestry choices = All - (Fixed Same - Fixed Other) - (Selected Same - Fixed Other) - Selected Other
-}
validAncestryChoices : List a -> List a -> List a -> List a -> List a -> List a
validAncestryChoices fixedSame fixedOther selectedSame selectedOther list =
    list
        |> filterList (filterList fixedOther fixedSame)
        |> filterList (filterList fixedOther selectedSame)
        |> filterList selectedOther


fixedAbilities : List Ability.AbilityMod -> List Ability
fixedAbilities mods =
    List.filterMap
        (\abilityMod ->
            case abilityMod of
                Ability.Fixed ability ->
                    Just ability
                Ability.Choice _ ->
                    Nothing
        )
        mods


type alias BoostsAndFlaws a b =
    { a
        | abilityBoosts : b
        , abilityFlaws : b
    }


optionField : AbilityModType -> Bool -> (BoostsAndFlaws a b -> b)
optionField modType invert =
    case (modType, invert) of
        (Boost, True) -> .abilityBoosts
        (Boost, False) -> .abilityFlaws
        (Flaw, True) -> .abilityFlaws
        (Flaw, False) -> .abilityBoosts


renderBackground : State -> Element Msg
renderBackground state =
    El.column
        box
        [ UI.Text.header2 "Background"
        , case state.character.background of
            Nothing ->
                UI.Button.render
                    { onPress = Just <| Msg.OpenModal View.Background
                    , label = El.text "Select a Background first"
                    }
            Just background ->
                El.column
                    [ El.spacing 10
                    , El.width El.fill
                    ]
                    [ UI.Button.render
                        { onPress = Just <| Msg.OpenModal View.Background
                        , label = El.text background.name
                        }
                    , El.column
                        box
                        ( [ UI.Text.header3 "Ability Boosts" ]
                        ++
                        ( List.indexedMap (renderBackgroundMod background state.character)
                            <| Character.backgroundAbilityBoosts state.character
                        )
                        )
                    ]
        ]


renderBackgroundMod : Data.Background -> Character -> Int -> Ability.AbilityMod -> Element Msg
renderBackgroundMod background character index mod =
    case mod of
        Ability.Fixed ability ->
            El.text <| Ability.toString ability
        Ability.Choice list ->
            UI.ChooseOne.render
                { all = list
                , selected = Dict.get index character.backgroundOptions.abilityBoosts
                , available =
                    filterList
                        (Dict.values character.backgroundOptions.abilityBoosts)
                        list
                , onChange = Msg.Background << Background.SetAbilityBoost index
                , toString = Ability.toString
                }


renderClass : State -> Element Msg
renderClass state =
    El.column
        box
        [ UI.Text.header2 "Class"
        , case state.character.class of
            Nothing ->
                UI.Button.render
                    { onPress = Just <| Msg.OpenModal View.Class
                    , label = El.text "Select a Class first"
                    }
            Just class ->
                El.column
                    [ El.spacing 10
                    , El.width El.fill
                    ]
                    [ UI.Button.render
                        { onPress = Just <| Msg.OpenModal View.Class
                        , label = El.text class.name
                        }
                    , El.column
                        box
                        [ UI.Text.header3 "Key Ability"
                        , renderClassMod class state.character
                        ]
                    ]
        ]


renderClassMod : Data.Class -> Character -> Element Msg
renderClassMod class character =
    case class.keyAbility of
        Ability.Fixed ability ->
            El.text <| Ability.toString ability
        Ability.Choice list ->
            UI.ChooseOne.render
                { all = list
                , selected = character.classOptions.keyAbility
                , available = list
                , onChange = Msg.Class << Class.SetKeyAbility
                , toString = Ability.toString
                }


renderFree : State -> Int -> Element Msg
renderFree state level =
    case state.character.baseAbilities of
        Ability.Standard ->
            El.column
                box
                [ UI.Text.header2 "Free Ability Boosts"
                , UI.ChooseMany.render
                    { all = Ability.list
                    , selected =
                        state.character.abilityBoosts
                            |> Dict.get level
                            |> Maybe.withDefault []
                    , max = 4
                    , onChange = Msg.Abilities << Abilities.SetAbilityBoosts level
                    , toString = Ability.toString
                    }
                ]
        Ability.Rolled _ ->
            El.none


renderFreeMod character index =
    UI.ChooseOne.render
        { all = Ability.list
        , selected = Nothing
        , available = Ability.list
        , onChange = \_ -> Msg.NoOp
        , toString = Ability.toString
        }


renderTotal : State -> Int -> Element Msg
renderTotal state level =
    El.column
        box
        [ UI.Text.header2 "Total"
        , El.table
            []
            { data =
                List.map
                    (pairTotalInputs <| Character.abilities level state.character)
                    [ (Ability.Str, Ability.Int)
                    , (Ability.Dex, Ability.Wis)
                    , (Ability.Con, Ability.Cha)
                    ]
            , columns =
                [ { header = El.text "Ability"
                  , width = El.shrink
                  , view = \row -> El.text row.label1
                  }
                , { header = El.text "Score"
                  , width = El.px 60
                  , view = \row -> El.text <| String.fromInt row.value1
                  }
                , { header = El.text "Mod"
                  , width = El.px 60
                  , view = El.text << Fun.formatModifier << Ability.modifier << .value1
                  }
                , { header = El.text "Ability"
                  , width = El.shrink
                  , view = \row -> El.text row.label2
                  }
                , { header = El.text "Score"
                  , width = El.px 60
                  , view = \row -> El.text <| String.fromInt row.value2
                  }
                , { header = El.text "Mod"
                  , width = El.px 60
                  , view = El.text << Fun.formatModifier << Ability.modifier << .value2
                  }
                ]
            }
        ]


pairTotalInputs abilities (ability1, ability2) =
    { label1 = Ability.toString ability1
    , value1 = Ability.abilityValue ability1 <| abilities
    , label2 = Ability.toString ability2
    , value2 = Ability.abilityValue ability2 <| abilities
    }


filterList : List a -> List a -> List a
filterList filter list =
    List.filter (\v -> not <| List.member v filter) list


box =
    [ Background.color <| El.rgb 0.9 0.9 0.9
    , Border.width 1
    , Border.rounded 2
    , El.padding 5
    , El.width El.fill
    , El.spacing 5
    ]
