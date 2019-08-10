module View.Ancestry exposing (render)

import Dict exposing (Dict)

import Maybe.Extra
import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Character as Character exposing (Character)
import UI.ChooseOne

type alias State s =
    { s
        | currentCharacter : Character
        , data : Data
    }


type AbilityModType
    = Boost
    | Flaw


render : State s -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        ]
        <| List.filterMap identity
            [ renderAncestryChoice state
            , renderAncestryOptions state
            ]


renderAncestryChoice : State s -> Maybe (Element Msg)
renderAncestryChoice state =
    Just <| El.column
        [ El.spacing 5 ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Ancestry"
        , UI.ChooseOne.render
            { all = Dict.values state.data.ancestries
            , available = Dict.values state.data.ancestries
            , selected = state.currentCharacter.ancestry
            , onChange = Msg.Ancestry << Ancestry.SetAncestry
            , toString = .name
            }
        ]


renderAncestryOptions state =
    case state.currentCharacter.ancestry of
        Just ancestry ->
            Just <| El.column
                [ El.width El.fill
                ]
                [ abilityBoosts ancestry state.currentCharacter
                ]

        Nothing ->
            Nothing


abilityBoosts : Ancestry -> Character -> Element Msg
abilityBoosts ancestry character =
    El.column
        [ El.spacing 10
        ]
        (
        [ El.el
            [ Font.heavy
            ]
            <| El.text "Ability Boosts"
        , El.row
            []
            [ Input.checkbox
                []
                { onChange = Msg.Ancestry << Ancestry.SetVoluntaryFlaw
                , icon = Input.defaultCheckbox
                , checked =
                    Maybe.map .voluntaryFlaw character.ancestryOptions
                        |> Maybe.withDefault False
                , label =
                    Input.labelRight
                        []
                        <| El.text "Voluntary Flaw"
                }
            ]
        , El.column
            [ El.spacing 15 ]
            <| List.indexedMap (renderAbilityMod ancestry character Boost)
            <| Character.ancestryAbilityBoosts character
        ]
        ++
        if List.isEmpty <| Character.ancestryAbilityFlaws character then
            []
        else
            [ El.el
                [ Font.heavy
                ]
                <| El.text "Ability Flaws"
            , El.column
                [ El.spacing 15 ]
                <| List.indexedMap (renderAbilityMod ancestry character Flaw)
                <| Character.ancestryAbilityFlaws character
            ]
        )


renderAbilityMod : Ancestry -> Character -> AbilityModType -> Int -> Ability.AbilityMod -> Element Msg
renderAbilityMod ancestry character modType index mod =
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
