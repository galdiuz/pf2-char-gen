module View.Class exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Font as Font

import Action.Class as Class
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
        ]
        [ UI.Layout.box
            [ UI.Text.header1  "Select Class"
            , UI.ChooseOne.render
                { all = Dict.values state.data.classes
                , available = Dict.values state.data.classes
                , selected = state.character.class
                , onChange = Msg.Class << Class.SetClass
                , toString = .name
                }
            ]
        ]
