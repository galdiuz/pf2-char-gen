module View.Skill exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Maybe.Extra

import Action.Skill as Skill
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Fun
import Pathfinder2.Ability as Ability
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data
import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)
import UI.Button
import UI.ButtonGrid
import UI.Text


render : State -> Int -> Int -> Element Msg
render state level picks =
    El.column
        [ El.scrollbarY
        , El.spacing 20
        ]
        [ UI.Text.header2 "Skills"
        , if picks == 1 then
            UI.ButtonGrid.renderChooseOne
                { all = List.sortWith Data.compareSkills <| Dict.values <| Data.skills state.data
                , available =
                    Data.skills state.data
                        |> Character.availableSkills level state.character
                        |> Dict.values
                , selected =
                    state.character.skillIncreases
                        |> Dict.get level
                        |> Maybe.withDefault []
                        |> List.head
                , onChange = Msg.Skill << Skill.SetSkillIncrease level << List.singleton
                , columns = columns state level
                }
        else
            UI.ButtonGrid.renderChooseMany
                { all = List.sortWith Data.compareSkills <| Dict.values <| Data.skills state.data
                , available =
                    Data.skills state.data
                        |> Character.availableSkills level state.character
                        |> Dict.values
                , selected =
                    state.character.skillIncreases
                        |> Dict.get level
                        |> Maybe.withDefault []
                , onChange = Msg.Skill << Skill.SetSkillIncrease level
                , columns = columns state level
                , max = picks
                }
        , El.row
            [ El.spacing 5 ]
            [ Input.text
                []
                { onChange = Msg.Skill << Skill.SetLoreSkillInput
                , text = state.inputs.loreSkill
                , placeholder = Nothing
                , label = Input.labelHidden "Add lore skill"
                }
            , El.text "Lore"
            , UI.Button.render
                { onPress = Just <| Msg.Skill <| Skill.AddLoreSkill state.inputs.loreSkill
                , label = El.text "Add Lore Skill"
                }
            ]
        ]


columns : State -> Int -> List (Data.Skill -> Element Msg)
columns state level =
    let
        proficiency skill =
            Character.skillProficiency skill.name level state.character
        proficiencyMod skill =
            Proficiency.modifier (proficiency skill) level
        abilityMod skill =
            Character.abilities level state.character
                |> Ability.abilityValue skill.keyAbility
                |> Ability.modifier
    in
    [ \skill ->
        El.el
            [ El.centerY
            ]
            <| El.text skill.name
    , \skill ->
        El.el
            [ El.centerY
            , Font.alignRight
            , El.width <| El.minimum 30 El.fill
            ]
            <| El.text <| (Fun.formatModifier (proficiencyMod skill + abilityMod skill))
    , \skill ->
        El.el
            [ El.centerY
            ]
            <| El.text "="
    , \skill ->
        El.el
            [ El.centerY
            ]
            <| renderProficiency (proficiency skill)
    , \skill ->
        El.column
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
    , \skill ->
        El.el
            [ El.centerY
            ]
            <| El.text "+"
    , \skill ->
        El.column
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
    ]


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
