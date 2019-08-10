module View.Build exposing (render)

import Dict exposing (Dict)

import Maybe.Extra
import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import Action.Ancestry as Ancestry
import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import UI.Button
import UI.ChooseOne
import App.View as View

render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 10
        , El.padding 10
        ]
        [ UI.Button.render
            { onClick = Msg.SetModal View.Ancestry
            , text =
                "Ancestry: "
                ++
                (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.ancestry)
            }
        , UI.Button.render
            { onClick = Msg.SetModal View.Background
            , text =
                "Background: "
                ++
                (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.background)
            }
        , UI.Button.render
            { onClick = Msg.SetModal View.Class
            , text =
                "Class: "
                ++
                (Maybe.withDefault "Not Selected" <| Maybe.map .name state.character.class)
            }
        , UI.Button.render
            { onClick = Msg.SetModal View.Abilities
            , text =
                "Abilities"
            }
        ]
