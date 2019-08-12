module View.Build exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border

import Action.Ancestry as Ancestry
import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.View as View
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
        , renderFreeBoosts state level
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
                , label = El.text <|
                    "Ancestry: "
                    ++
                    (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.ancestry)
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Background
                , label = El.text <|
                    "Background: "
                    ++
                    (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.background)
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Class
                , label = El.text <|
                    "Class: "
                    ++
                    (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.class)
                }
            , UI.Button.render
                { onPress = Just <| Msg.OpenModal View.Abilities
                , label = El.text <|
                    "Abilities"
                }
            ]
    else
        El.none


renderFreeBoosts state level =
    if List.member level [5, 10, 15, 20] then
        UI.Button.render
            { onPress = Nothing
            , label = El.text <|
                "Ability Boosts"
            }
    else
        El.none


renderAncestryFeats state level =
    if List.member level [1, 5, 9, 13, 17] then
        UI.Button.render
            { onPress = Nothing
            , label = El.text <|
                "Ancestry Feat"
            }
    else
        El.none


renderClassFeats state level =
    if List.member level [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20] then
        UI.Button.render
            { onPress = Nothing
            , label = El.text <|
                "Class Feat"
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
            , label = El.text <|
                "Skill Increase"
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
            , label = El.text <|
                "Skill Feat"
            }
    else
        El.none


renderGeneralFeats state level =
    if List.member level [3, 7, 11, 15, 19] then
        UI.Button.render
            { onPress = Nothing
            , label = El.text <|
                "General Feat"
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
