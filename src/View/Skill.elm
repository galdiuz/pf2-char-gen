module View.Skill exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font

import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Fun
import Pathfinder2.Ability as Ability
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data
import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)
import UI.Button


render : State -> Int -> Element Msg
render state level =
    let
        proficiency skill =
            Character.skillProficiency skill.name level state.character
        proficiencyMod skill =
            Proficiency.modifier (proficiency skill) level
        abilityMod skill =
            Character.abilities level state.character
                |> Ability.abilityValue skill.keyAbility
                |> Ability.modifier
        onClick skill =
            Events.onClick Msg.NoOp
    in
    El.table
        [ El.spacingXY 0 5
        ]
        { data = Dict.values state.data.skills
        , columns =
            [ { header = El.none
              , width = El.shrink
              , view =
                  \skill ->
                    El.el
                        [ Border.widthEach
                            { top = 1
                            , bottom = 1
                            , left = 1
                            , right = 0
                            }
                        , El.padding 5
                        , El.height El.fill
                        , El.pointer
                        , Background.color <| El.rgb 1 1 1
                        , onClick skill
                        ]
                        <| El.el
                            [ El.centerY
                            ]
                            <| El.text skill.name
              }
            , { header = El.none
              , width = El.shrink
              , view =
                  \skill ->
                    El.el
                        [ Border.widthXY 0 1
                        , El.padding 5
                        , El.height El.fill
                        , El.pointer
                        , Background.color <| El.rgb 1 1 1
                        , onClick skill
                        ]
                        <| El.el
                            [ El.centerY
                            , Font.alignRight
                            , El.width El.fill
                            ]
                            <| El.text <| (Fun.formatModifier (proficiencyMod skill + abilityMod skill)) ++ " ="
              }
            , { header = El.none
              , width = El.shrink
              , view =
                  \skill ->
                    El.row
                        [ Border.widthXY 0 1
                        , El.padding 5
                        , El.height El.fill
                        , El.pointer
                        , Background.color <| El.rgb 1 1 1
                        , onClick skill
                        , El.spacing 5
                        ]
                        [ renderProficiency (proficiency skill)
                        , El.column
                            [ Font.center
                            , El.width El.fill
                            ]
                            [ El.el
                                [ El.width El.fill ]
                                <| El.text <| Proficiency.toString (proficiency skill)
                            , El.el
                                [ El.width El.fill ]
                                <| El.text <| Fun.formatModifier (proficiencyMod skill)
                            ]
                        , El.text " +"
                        ]
              }
            , { header = El.none
              , width = El.shrink
              , view =
                  \skill ->
                    El.el
                        [ Border.widthEach
                            { top = 1
                            , bottom = 1
                            , left = 0
                            , right = 1
                            }
                        , El.padding 5
                        , El.height El.fill
                        , El.pointer
                        , Background.color <| El.rgb 1 1 1
                        , onClick skill
                        ]
                        <| El.column
                            [ Font.center
                            , El.width El.fill
                            ]
                            [ El.el
                                [ El.width El.fill ]
                                <| El.text <| Ability.toString skill.keyAbility
                            , El.el
                                [ El.width El.fill ]
                                <| El.text <| Fun.formatModifier <| abilityMod skill
                            ]
              }
            ]
        }


renderProficiency : Proficiency -> Element Msg
renderProficiency rank =
    let
        style proficiency attributes =
            if Proficiency.compare rank proficiency == LT then
                [ Border.dashed
                , Border.color <| El.rgb 0.5 0.5 0.5
                , Font.color <| El.rgb 0.5 0.5 0.5
                ]
                ++ attributes
            else
                [ Border.solid
                ]
                ++ attributes
    in
    El.row
        [ El.alignRight
        ]
        [ El.el
            ( style Proficiency.Trained
                [ Border.width 1
                , El.padding 2
                ]
            )
            <| El.text "T"
        , El.el
            ( style Proficiency.Expert
                [ Border.widthEach
                    { top = 1
                    , bottom = 1
                    , left = 0
                    , right = 1
                    }
                , El.padding 2
                ]
            )
            <| El.text "E"
        , El.el
            ( style Proficiency.Master
                [ Border.widthEach
                    { top = 1
                    , bottom = 1
                    , left = 0
                    , right = 1
                    }
                , El.padding 2
                ]
            )
            <| El.text "M"
        , El.el
            ( style Proficiency.Legendary
                [ Border.widthEach
                    { top = 1
                    , bottom = 1
                    , left = 0
                    , right = 1
                    }
                , El.padding 2
                ]
            )
            <| El.text "L"
        ]
