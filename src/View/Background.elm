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
        ]
        <| List.filterMap identity
            [ renderBackgroundChoice state
            , renderBackgroundOptions state
            ]


renderBackgroundChoice : State -> Maybe (Element Msg)
renderBackgroundChoice state =
    Just <| El.column
        [ El.spacing 5
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Background"
        , UI.ChooseOne.render
            { all = Dict.values state.data.backgrounds
            , available = Dict.values state.data.backgrounds
            , selected = state.currentCharacter.background
            , onChange = Msg.Background << Background.SetBackground
            , toString = .name
            }
        ]


renderBackgroundOptions : State -> Maybe (Element Msg)
renderBackgroundOptions state =
    case state.currentCharacter.background of
        Just background ->
            Just <| El.column
                []
                [ abilityBoosts background state.currentCharacter
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
                    character.backgroundOptions
                        |> Maybe.map .abilityBoosts
                        |> Maybe.map (Dict.get index)
                        |> Maybe.Extra.join
                , available =
                    filterList
                        (character.backgroundOptions
                            |> Maybe.map .abilityBoosts
                            |> Maybe.withDefault Dict.empty
                            |> Dict.values
                        )
                        list
                , onChange = Msg.Background << Background.SetAbilityBoost index
                , toString = Ability.toString
                }


filterList : List a -> List a -> List a
filterList filter list =
    List.filter (\v -> not <| List.member v filter) list
