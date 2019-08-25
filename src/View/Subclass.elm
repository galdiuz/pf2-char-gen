module View.Subclass exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Font as Font

import Action.Class as Class
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Data as Data
import UI.ChooseOne
import UI.Layout
import UI.Text


render : State -> Data.Subclass -> Element Msg
render state subclass =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.height El.fill
        , El.scrollbarY
        ]
        [ UI.Layout.box
            [ UI.Text.header1 <| "Select " ++ subclass.name
            , UI.ChooseOne.render
                { all = subclass.options
                , available = subclass.options
                , selected = state.character.classOptions.subclass
                , onChange = Msg.Class << Class.SetSubclass
                , toString = identity
                }
            ]
        ]
