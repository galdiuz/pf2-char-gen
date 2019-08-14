module View.Skill exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
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
        proficiencyMod =
            Proficiency.modifier proficiency level
        abilityMod =
            Character.abilities level character
                |> Ability.abilityValue skill.keyAbility
                |> Ability.modifier
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
                    [ El.text <| Fun.formatModifier (proficiencyMod + abilityMod)
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
                            <| El.text <| Fun.formatModifier proficiencyMod
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
                            <| El.text <| Fun.formatModifier abilityMod
                        ]
                    ]
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
