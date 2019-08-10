module View.Abilities exposing (render)

import Dict exposing (Dict)

import Element as El exposing (Element)
import Element.Font as Font
import Element.Input as Input
import Maybe.Extra

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Character as Character exposing (Character)
import UI.ChooseOne


type AbilityModType
    = Boost
    | Flaw


render : State -> Element Msg
render state =
    El.column
        [ El.spacing 20 ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Abilities"
        , renderBaseAbilities state
        , renderAncestry state
        , renderBackground state
        , renderClass state
        ]


renderBaseAbilities state =
    El.column
        []
        [ El.text <| "Base Abilities"
        , UI.ChooseOne.render
            { all = [ "Standard", "Rolled" ]
            , available = [ "Standard" ]
            , selected = Nothing
            , onChange = \_ -> Msg.NoOp
            , toString = identity
            }
        ]


renderRolled state =
    El.none


renderAncestry state =
    El.column
        []
        [ El.text <| "Ancestry"
        , case state.character.ancestry of
            Nothing ->
                El.el
                    [ Font.color <| El.rgb 0.75 0 0 ]
                    <| El.text "Select an Ancestry first"

            Just ancestry ->
                El.column
                    [ El.spacing 10 ]
                    [ Input.checkbox
                        []
                        { onChange = Msg.Ancestry << Ancestry.SetVoluntaryFlaw
                        , icon = Input.defaultCheckbox
                        , checked =
                            Maybe.map .voluntaryFlaw state.character.ancestryOptions
                                |> Maybe.withDefault False
                        , label =
                            Input.labelRight
                                []
                                <| El.text "Voluntary Flaw"
                        }
                    , El.text "Boosts"
                    , El.column
                        []
                        <| List.indexedMap (renderAncestryMod ancestry state.character Boost)
                        <| Character.ancestryAbilityBoosts state.character
                    , El.text "Flaws"
                    , El.column
                        []
                        <| List.indexedMap (renderAncestryMod ancestry state.character Flaw)
                        <| Character.ancestryAbilityFlaws state.character
                    ]
        ]


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
                        |> Maybe.map (optionField modType True)
                        |> Maybe.map (Dict.get index)
                        |> Maybe.Extra.join
                , available =
                    validChoices
                        (mapAbilityList <| optionField modType True <| ancestry)
                        (mapAbilityList <| optionField modType False <| ancestry)
                        (character.ancestryOptions
                            |> Maybe.map (optionField modType True)
                            |> Maybe.withDefault Dict.empty
                            |> Dict.remove index
                            |> Dict.values
                        )
                        (character.ancestryOptions
                            |> Maybe.map (optionField modType False)
                            |> Maybe.withDefault Dict.empty
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


{-| Valid ability choices = All - (Ancestry Same - Ancestry Other) - (Selected Same - Ancestry Other) - Selected Other
-}
validChoices : List a -> List a -> List a -> List a -> List a -> List a
validChoices ancestrySame ancestryOther selectedSame selectedOther list =
    list
        |> filterList (filterList ancestryOther ancestrySame)
        |> filterList (filterList ancestryOther selectedSame)
        |> filterList selectedOther


mapAbilityList : List Ability.AbilityMod -> List Ability
mapAbilityList mods =
    List.filterMap
        (\abilityMod ->
            case abilityMod of
                Ability.Fixed ability ->
                    Just ability
                Ability.Choice _ ->
                    Nothing
        )
        mods


filterList : List a -> List a -> List a
filterList filter list =
    List.filter (\v -> not <| List.member v filter) list


optionField modType invert =
    case (modType, invert) of
        (Boost, True) -> .abilityBoosts
        (Boost, False) -> .abilityFlaws
        (Flaw, True) -> .abilityFlaws
        (Flaw, False) -> .abilityBoosts



renderBackground state =
    El.column
        []
        [ El.text <| "Background"
        ]


renderClass state =
    El.column
        []
        [ El.text <| "Class"
        ]
