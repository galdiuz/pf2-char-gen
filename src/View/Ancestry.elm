module View.Ancestry exposing (render)

import Dict

import Element exposing (Element, text, el)
import Element as El
import Element.Events as Events
import Element.Input as Input
import Element.Border as Border
import Element.Background as Background

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
        []
        [ el
            []
            <| text "Ancestry"
        , Input.radioRow
            [ Element.spacing 5 ]
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
                Input.Idle ->
                    [ Border.width 1
                    , Border.dashed
                    , Element.padding 2
                    ]

                Input.Focused ->
                    [ Border.width 1
                    , Element.padding 2
                    ]

                Input.Selected ->
                    [ Border.width 1
                    , Element.padding 2
                    , Background.color <| Element.rgb255 192 192 192
                    ]
    in
        el style <| text ancestry.name


renderAncestryOptions state =
    case state.currentCharacter.ancestry.ancestry of
        Just ancestry ->
            Just <| Element.column
                []
                [ abilityBoosts ancestry state.currentCharacter.ancestry.options state.currentCharacter
                ]

        Nothing ->
            Nothing


abilityBoosts ancestry options character =
    El.column
        [ El.spacing 10
        ]
        [ El.text "Ability Boosts"
        , El.column
            [ El.spacing 5 ]
            <| List.indexedMap (a ancestry options) <| Character.getAbilityBoosts character
        , El.text "Ability Flaws"
        , El.column
            [ El.spacing 5 ]
            <| List.indexedMap (a ancestry options) <| Character.getAbilityFlaws character
        ]


--a : Ancestry -> Options -> Int -> AbilityMod
a ancestry options index boost =
    let
        button text =
            El.el
                [ Border.width 1
                , El.padding 2
                ]
                <| El.text text
    in
    case boost of
        Ability.Ability ability ->
            El.text <| Ability.abilityToString ability
        Ability.Free ->
            El.row
                [ El.spacing 5 ]
                <| List.append (List.singleton <| text "Choose one: ")
                <| List.map (button << Ability.abilityToString) Ability.allAbilities


--validBoosts
