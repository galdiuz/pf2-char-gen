module View.Ancestry exposing (render)

import Dict exposing (Dict)

import Maybe.Extra
import Element exposing (Element, text, el)
import Element as El
import Element.Events as Events
import Element.Input as Input
import Element.Border as Border
import Element.Background as Background
import Element.Font as Font

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Character as Character exposing (Character)

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
    Element.column
        [ Element.alignTop ]
        <| List.filterMap identity
            [ renderAncestryChoice state
            , renderAncestryOptions state
            ]


renderAncestryChoice state =
    Just <| Element.column
        [ El.spacing 5 ]
        [ el
            [ Font.bold
            , Font.size 24
            ]
            <| text "Ancestry"
        , Input.radioRow
            [ Element.spacing 5
            , Element.paddingXY 0 10
            ]
            { onChange = \value -> Msg.Ancestry <| Ancestry.SetAncestry value
            , options =
                state.data.ancestries
                    |> Dict.toList
                    |> List.map
                        (\(key, ancestry) ->
                            Input.optionWith key (renderAncestry ancestry)
                        )
            , selected = Maybe.map .name state.currentCharacter.ancestry.ancestry
            , label = Input.labelHidden ""
            }
        ]


renderAncestry : Ancestry -> Input.OptionState -> Element Msg
renderAncestry ancestry optionState =
    let
        style =
            case optionState of
                Input.Selected ->
                    [ Border.width 2
                    , Element.padding 4
                    , Background.color <| Element.rgb 0.8 0.8 0.8
                    ]

                _ ->
                    [ Border.width 1
                    , Element.padding 5
                    ]
    in
        el style <| text ancestry.name


renderAncestryOptions state =
    case state.currentCharacter.ancestry.ancestry of
        Just ancestry ->
            Just <| Element.column
                []
                [ abilityBoosts ancestry state.currentCharacter
                ]

        Nothing ->
            Nothing


abilityBoosts ancestry character =
    El.column
        [ El.spacing 10
        ]
        [ El.el
            [ Font.heavy
            ]
            <| El.text "Ability Boosts"
        , El.column
            [ El.spacing 5 ]
            <| List.indexedMap (renderAbilityMod ancestry character Boost)
            <| Character.getAbilityBoosts character
        , El.el
            [ Font.heavy
            ]
            <| El.text "Ability Flaws"
        , El.column
            [ El.spacing 5 ]
            <| List.indexedMap (renderAbilityMod ancestry character Flaw)
            <| Character.getAbilityFlaws character
        ]


renderAbilityMod : Ancestry -> Character -> AbilityModType -> Int -> Ability.AbilityMod -> Element Msg
renderAbilityMod ancestry character modType index mod =
    case mod of
        Ability.Ability ability ->
            El.text <| Ability.abilityToString ability
        Ability.Free ->
            El.row
                [ El.spacing 5 ]
                --<| List.append (List.singleton <| text "Choose one: ")
                <| List.map (renderAbilityButton ancestry character.ancestry.options modType index) Ability.allAbilities


renderAbilityButton : Ancestry -> Maybe Character.AncestryOptions -> AbilityModType -> Int -> Ability -> Element Msg
renderAbilityButton ancestry options modType index ability =
    let
        actionType =
            case modType of
                Boost -> Ancestry.SetAbilityBoost
                Flaw -> Ancestry.SetAbilityFlaw

        optionField invert =
            case (modType, invert) of
                (Boost, True) -> .abilityBoosts
                (Boost, False) -> .abilityFlaws
                (Flaw, True) -> .abilityFlaws
                (Flaw, False) -> .abilityBoosts

        activeStyle =
            [ Border.width 1
            , El.padding 5
            , Events.onClick <| Msg.Ancestry <| actionType index ability
            , El.pointer
            ]

        selectedStyle =
            [ Border.width 2
            , El.padding 4
            , Background.color <| El.rgb 0.8 0.8 0.8
            ]

        inactiveStyle =
            [ Border.width 1
            , Border.dashed
            , Border.color <| El.rgb 0.5 0.5 0.5
            , Font.color <| El.rgb 0.5 0.5 0.5
            , El.padding 5
            ]

        isSelected =
            Maybe.map (optionField True) options
                |> Maybe.map (Dict.get index)
                |> (==) (Just <| Just ability)

        isValidChoice =
            List.member ability
                <| validChoices
                    (mapAbilityList <| optionField True ancestry)
                    (mapAbilityList <| optionField False ancestry)
                    (Maybe.map (optionField True) options
                        |> Maybe.withDefault Dict.empty
                        |> Dict.remove index
                        |> Dict.values
                    )
                    (Maybe.map (optionField False) options
                        |> Maybe.withDefault Dict.empty
                        |> Dict.values
                    )

        style =
            if isSelected then
                selectedStyle
            else if isValidChoice then
                activeStyle
            else
                inactiveStyle
    in
    El.el
        style
        <| text <| Ability.abilityToString ability



mapAbilityList : List Ability.AbilityMod -> List Ability
mapAbilityList mods =
    List.filterMap
        (\abilityMod ->
            case abilityMod of
                Ability.Ability ability ->
                    Just ability
                Ability.Free ->
                    Nothing
        )
        mods


{-| Valid ability choices = All - (Ancestry Same - Ancestry Other) - (Selected Same - Ancestry Other) - Selected Other
-}
validChoices : List Ability -> List Ability -> List Ability -> List Ability -> List Ability
validChoices ancestrySame ancestryOther selectedSame selectedOther =
    Ability.allAbilities
        |> diffList (diffList ancestryOther ancestrySame)
        |> diffList (diffList ancestryOther selectedSame)
        |> diffList selectedOther


diffList : List a -> List a -> List a
diffList toRemove list =
    List.filter (\v -> not <| List.member v toRemove) list
