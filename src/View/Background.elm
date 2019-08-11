module View.Background exposing (render)

import Dict

import Maybe.Extra
import Element as El exposing (Element)
import Element.Border as Border
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Background as Background exposing (Background)
import Pathfinder2.Character as Character exposing (Character)
import UI.ChooseOne


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 5
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Background"
        , UI.ChooseOne.render
            { all = Dict.values state.data.backgrounds
            , available = Dict.values state.data.backgrounds
            , selected = state.character.background
            , onChange = Msg.Background << Background.SetBackground
            , toString = .name
            }
        ]





renderBackgroundOptions : State -> Maybe (Element Msg)
renderBackgroundOptions state =
    case state.character.background of
        Just background ->
            Just <| El.column
                []
                [ abilityBoosts background state.character
                ]

        Nothing ->
            Nothing


abilityBoosts : Background -> Character -> Element Msg
abilityBoosts background character =
    El.column
        []
        [ El.el
            [ Font.heavy
            ]
            <| El.text "Ability Boosts"
        , El.column
            [ El.spacing 15
            ]
            <| List.indexedMap (renderAbilityMod background character)
            <| Character.backgroundAbilityBoosts character
        ]


renderAbilityMod background character index mod =
    case mod of
        Ability.Fixed ability ->
            El.text <| Ability.toString ability
        Ability.Choice list ->
            UI.ChooseOne.render
                { all = list
                , selected =
                    character.backgroundOptions.abilityBoosts
                        |> Dict.get index
                , available =
                    filterList
                        (Dict.values character.backgroundOptions.abilityBoosts)
                        list
                , onChange = Msg.Background << Background.SetAbilityBoost index
                , toString = Ability.toString
                }


filterList : List a -> List a -> List a
filterList filter list =
    List.filter (\v -> not <| List.member v filter) list
