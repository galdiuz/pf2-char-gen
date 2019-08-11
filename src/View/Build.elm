module View.Build exposing (render)

import Element as El exposing (Element)

import Action.Ancestry as Ancestry
import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.View as View
import UI.Button
import UI.ChooseOne


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 10
        , El.padding 10
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
