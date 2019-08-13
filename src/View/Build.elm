module View.Build exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border

import Action.Ancestry as Ancestry
import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.View as View
import Pathfinder2.Ability as Ability exposing (Ability)
import UI.Button
import UI.ChooseOne
import UI.Text


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 10
        , El.padding 10
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
                , label = El.text <|
                    "Ability Boosts"
                }
            , UI.Button.render
                { onPress = Just <| Msg.NoOp
                , label =
                    El.column
                        []
                        [ UI.Text.label "Heritage"
                        , El.text <| Maybe.withDefault "<Not selected>" <| Nothing
                        ]
                }
            ]
    else
        El.none


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


renderAncestryFeats state level =
    if List.member level [1, 5, 9, 13, 17] then
        UI.Button.render
            { onPress = Nothing
            , label =
                El.column
                    []
                    [ UI.Text.label "Ancestry Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderClassFeats state level =
    if List.member level [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20] then
        UI.Button.render
            { onPress = Nothing
            , label =
                El.column
                    []
                    [ UI.Text.label "Class Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderSkillIncreases state level =
    let
        levels =
            state.character.class
                |> Maybe.map .skillIncreases
                |> Maybe.withDefault []
    in
    if List.member level levels then
        UI.Button.render
            { onPress = Nothing
            , label =
                El.column
                    []
                    [ UI.Text.label "Skill Increase"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderSkillFeats state level =
    let
        levels =
            state.character.class
                |> Maybe.map .skillFeats
                |> Maybe.withDefault []
    in
    if List.member level levels then
        UI.Button.render
            { onPress = Nothing
            , label =
                El.column
                    []
                    [ UI.Text.label "Skill Feat"
                    , El.text "<Not selected>"
                    ]
            }
    else
        El.none


renderGeneralFeats state level =
    if List.member level [3, 7, 11, 15, 19] then
        UI.Button.render
            { onPress = Nothing
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
    , El.width El.fill
    ]
