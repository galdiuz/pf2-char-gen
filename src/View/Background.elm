module View.Background exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Background as Background
import Element.Font as Font

import Action.Background as Background
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import UI.ChooseOne
import UI.Layout
import UI.Text


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.height El.fill
        , El.scrollbarY
        , El.spacing 5
        ]
        [ UI.Layout.box
            [ UI.Text.header1 "Background"
            , UI.ChooseOne.render
                { all = Dict.values state.data.backgrounds
                , available = Dict.values state.data.backgrounds
                , selected = state.character.background
                , onChange = Msg.Background << Background.SetBackground
                , toString = .name
                }
            ]
        ]
