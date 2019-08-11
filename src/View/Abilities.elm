module View.Abilities exposing (render)

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
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Data.Background as Background exposing (Background)
import Pathfinder2.Data.Class as Class exposing (Class)
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
        , renderFree state
        , renderTotal state
        ]


renderBaseAbilities : State -> Element Msg
renderBaseAbilities state =
    El.column
        box
        [ UI.Text.header2 "Base Abilities"
        , UI.ChooseOne.render
            { all = [ "Standard", "Rolled" ]
            , available = [ "Standard" ]
            , selected = Nothing
            , onChange = \_ -> Msg.NoOp
            , toString = identity
            }
        ]


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
                        ( [ UI.Text.header3 "Ability Boosts" ]
                        ++
                        ( List.indexedMap (renderAncestryMod ancestry state.character Boost)
                                <| Character.ancestryAbilityBoosts state.character
                        )
                        )
                    , El.column
                        box
                        ( [ UI.Text.header3 "Ability Flaws" ]
                        ++
                        ( List.indexedMap (renderAncestryMod ancestry state.character Flaw)
                            <| Character.ancestryAbilityFlaws state.character
                        )
                        )
                    ]
        ]


type AbilityModType
    = Boost
    | Flaw


renderAncestryMod : Ancestry -> Character -> AbilityModType -> Int -> Ability.AbilityMod -> Element Msg
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


renderBackgroundMod : Background -> Character -> Int -> Ability.AbilityMod -> Element Msg
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


renderClassMod : Class -> Character -> Element Msg
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


renderFree : State -> Element Msg
renderFree state =
    case state.character.abilities of
        Character.Standard ->
            El.column
                box
                [ UI.Text.header2 "Free Ability Boosts"
                , UI.ChooseMany.render
                    { all = Ability.allAbilities
                    , selected = state.character.freeBoosts
                    , max = 4
                    , onChange = Msg.Abilities << Abilities.SetAbilityBoosts
                    , toString = Ability.toString
                    }
                ]
        Character.Rolled _ _ _ _ _ _ ->
            El.none


renderFreeMod character index =
    UI.ChooseOne.render
        { all = Ability.allAbilities
        , selected = Nothing
        , available = Ability.allAbilities
        , onChange = \_ -> Msg.NoOp
        , toString = Ability.toString
        }


renderTotal : State -> Element Msg
renderTotal state =
    El.column
        box
        [ UI.Text.header2 "Total"
        , El.column
            []
            [ El.text "Strength"
            , El.text <| String.fromInt <| .str <| Character.abilities state.character
            ]
        ]


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
