module View.Build exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Maybe.Extra

import Action.Ancestry as Ancestry
import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.View as View
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)
import UI.Button
import UI.ChooseOne
import UI.Text


render : State -> Element Msg
render state =
    El.wrappedRow
        [ El.alignTop
        , El.spacing 10
        ]
        <| List.map (renderLevel state) <| List.range 1 20


renderLevel : State -> Int -> Element Msg
renderLevel state level =
    El.column
        box
        [ UI.Text.header1 <| "Level " ++ String.fromInt level
        , renderLevel1 state level
        , renderAbilityBoosts state level
        , renderAncestryFeats state level
        , renderClassFeats state level
        , renderSkillIncreases state level
        , renderSkillFeats state level
        , renderGeneralFeats state level
        ]


renderLevel1 : State -> Int -> Element Msg
renderLevel1 state level =
    if level == 1 then
        El.column
            [ El.spacing 5
            ]
            [ UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Ancestry
                , label =
                    El.column
                        []
                        [ UI.Text.label "Ancestry"
                        , El.text <| Maybe.withDefault "<Not selected>" <| Maybe.map .name state.character.ancestry
                        ]
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Background
                , label =
                    El.column
                        []
                        [ UI.Text.label "Background"
                        , El.text <| Maybe.withDefault "<Not selected>" <| Maybe.map .name state.character.background
                        ]
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Class
                , label =
                    El.column
                        []
                        [ UI.Text.label "Class"
                        , El.text <| Maybe.withDefault "<Not selected>" <| Maybe.map .name state.character.class
                        ]
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Abilities
                , label = UI.Text.label "Ability Boosts"
                }
            , if Maybe.Extra.isJust state.character.ancestry then
                UI.Button.render
                    { onPress = Just <| Msg.OpenModal View.Heritage
                    , label =
                        El.column
                            []
                            [ UI.Text.label "Heritage"
                            , El.text
                                ( state.character.ancestryOptions.heritage
                                    |> Maybe.map .name
                                    |> Maybe.withDefault "<Not selected>"
                                )
                            ]
                    }
              else
                El.none
            , if Maybe.Extra.isJust state.character.class then
                UI.Button.render
                    { onPress =
                        Just
                            <| Msg.OpenModal
                            <| View.Skill 1
                            <| Character.level1SkillIncreases state.character
                    , label =
                        El.column
                            []
                            [ UI.Text.label "Skills"
                            , El.text
                                <| selections
                                <| List.map .name
                                    ( state.character.skillIncreases
                                        |> Dict.get 1
                                        |> Maybe.withDefault []
                                    )
                            ]
                    }
              else
                El.none
            ]
    else
        El.none


renderAbilityBoosts : State -> Int -> Element Msg
renderAbilityBoosts state level =
    if List.member level [5, 10, 15, 20] then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.AbilityBoosts level
            , label =
                let
                    abilityBoosts =
                        state.character.abilityBoosts
                            |> Dict.get level
                            |> Maybe.withDefault []
                            |> List.sortWith Ability.compare
                in
                El.column
                    []
                    [ UI.Text.label "Ability Boosts"
                    , if List.length abilityBoosts < 4 then
                        El.text <| "<Remaining: " ++ String.fromInt (4 - List.length abilityBoosts) ++ ">"
                      else
                        El.none
                    , El.text
                        <| String.join ", "
                        <| List.map Ability.toString abilityBoosts
                    ]
            }
    else
        El.none


renderAncestryFeats : State -> Int -> Element Msg
renderAncestryFeats state level =
    if Maybe.Extra.isJust state.character.ancestry
      && List.member level [1, 5, 9, 13, 17] then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.Feat level "" "Ancestry"
            , label =
                El.column
                    []
                    [ UI.Text.label "Ancestry Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderClassFeats : State -> Int -> Element Msg
renderClassFeats state level =
    if Maybe.Extra.isJust state.character.class
      && List.member level [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20] then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.Feat
                level
                (String.fromInt level ++ "-class")
                (Maybe.withDefault "" <| Maybe.map .name state.character.class)
            , label =
                El.column
                    []
                    [ UI.Text.label "Class Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderSkillIncreases : State -> Int -> Element Msg
renderSkillIncreases state level =
    let
        levels =
            state.character.class
                |> Maybe.map .skillIncreaseLevels
                |> Maybe.withDefault []
    in
    if List.member level levels then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.Skill level 1
            , label =
                El.column
                    []
                    [ UI.Text.label "Skill Increase"
                    -- , El.text "<Not selected>"
                    , El.text
                        <| String.join ", "
                        <| List.map .name
                            ( state.character.skillIncreases
                                |> Dict.get level
                                |> Maybe.withDefault []
                            )
                    ]
            }
    else
        El.none


renderSkillFeats : State -> Int -> Element Msg
renderSkillFeats state level =
    let
        levels =
            state.character.class
                |> Maybe.map .skillFeatLevels
                |> Maybe.withDefault []
    in
    if List.member level levels then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.Feat level (String.fromInt level ++ "-skill") "Skill"
            , label =
                El.column
                    []
                    [ UI.Text.label "Skill Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderGeneralFeats : State -> Int -> Element Msg
renderGeneralFeats state level =
    if List.member level [3, 7, 11, 15, 19] then
        UI.Button.render
            { onPress = Just <| Msg.OpenModal <| View.Feat level (String.fromInt level ++ "-general") "General"
            , label =
                El.column
                    []
                    [ UI.Text.label "General Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


box =
    [ Background.color <| El.rgb 0.9 0.9 0.9
    , Border.width 1
    , Border.rounded 2
    , El.padding 5
    , El.spacing 5
    , El.alignTop
    ]


selections : List String -> String
selections list =
    if List.isEmpty list then
        "<Not selected>"
    else
        String.join ", " list
