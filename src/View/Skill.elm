module View.Skill exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font

import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Ability as Ability
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data
import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)
import UI.Button


render : State -> Int -> Element Msg
render state level =
    El.column
        [ El.spacing 5 ]
        <| List.map
            (\skill ->
                renderSkill skill level state.character
            )
        <| Dict.values state.data.skills


renderSkill : Data.Skill -> Int -> Character -> Element Msg
renderSkill skill level character =
    let
        proficiency =
            Character.skillProficiency skill.name level character
    in
    UI.Button.render
        { onPress = Nothing
        , label =
            El.row
                [ El.width <| El.px 500
                , El.spacing 20
                ]
                [ El.el
                    [ El.alignLeft
                    ]
                    <| El.text skill.name

                , El.row
                    [ El.alignRight
                    , El.spacing 5
                    ]
                    [ El.text <| "0"
                    , El.text "="
                    , renderProficiency proficiency
                    , El.column
                        [ Font.center
                        , El.width <| El.px 100
                        ]
                        [ El.el
                            [ El.width El.fill ]
                            <| El.text <| Proficiency.toString proficiency
                        , El.el
                            [ El.width El.fill ]
                            <| El.text <| Proficiency.bonusString proficiency level
                        ]
                    , El.text "+"
                    , El.column
                        [ Font.center
                        , El.width <| El.px 110
                        ]
                        [ El.el
                            [ El.width El.fill ]
                            <| El.text <| Ability.toString skill.keyAbility
                        , El.el
                            [ El.width El.fill ]
                            <| El.text <| Ability.modifierString 10
                        ]
                    ]
                ]
        }


renderProficiency : Proficiency -> Element Msg
renderProficiency proficiency =
    let
        unlocked =
            Background.color <| El.rgb 0.8 0.8 0.8

        locked =
            Background.color <| El.rgb 1 1 1

        background rank =
            if proficiency == Proficiency.Trained
                && rank == Proficiency.Trained
            then
                unlocked

            else if proficiency == Proficiency.Expert
                && List.member rank [Proficiency.Trained, Proficiency.Expert]
            then
                unlocked

            else if proficiency == Proficiency.Master
                && List.member rank [Proficiency.Trained, Proficiency.Expert, Proficiency.Master]
            then
                unlocked

            else if proficiency == Proficiency.Legendary
            then
                unlocked

            else
                locked
    in
    El.row
        [ El.alignRight
        ]
        [ El.el
            [ Border.widthEach
                { top = 1
                , bottom = 1
                , left = 1
                , right = 0
                }
            , El.padding 2
            , background Proficiency.Trained
            ]
            <| El.text "T"
        , El.el
            [ Border.widthEach
                { top = 1
                , bottom = 1
                , left = 1
                , right = 0
                }
            , El.padding 2
            , background Proficiency.Expert
            ]
            <| El.text "E"
        , El.el
            [ Border.widthEach
                { top = 1
                , bottom = 1
                , left = 1
                , right = 0
                }
            , El.padding 2
            , background Proficiency.Master
            ]
            <| El.text "M"
        , El.el
            [ Border.width 1
            , El.padding 2
            , background Proficiency.Legendary
            ]
            <| El.text "L"
        ]
