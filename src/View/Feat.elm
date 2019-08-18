module View.Feat exposing (render)

import Element as El exposing (Element)

import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import UI.ChooseOne


render : State -> Int -> List String -> Element Msg
render state level tags =
    El.column
        [ El.alignTop
        , El.width El.fill
        ]
        [ UI.ChooseOne.render
            { all = []
            , available = []
            , selected = Nothing
            , onChange = \_ -> Msg.NoOp
            , toString = .name
            }
        ]
