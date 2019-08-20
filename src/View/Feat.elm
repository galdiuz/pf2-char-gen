module View.Feat exposing (render)

import Dict

import Element as El exposing (Element)

import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Data as Data
import UI.ChooseOne


render : State -> Int -> String -> Element Msg
render state level tag =
    El.column
        [ El.alignTop
        , El.width El.fill
        ]
        [ UI.ChooseOne.render
            { all =
                state.data.feats
                    |> Data.filterFeatTag tag
                    |> Dict.values
            , available =
                state.data.feats
                    |> Data.filterFeatTag tag
                    |> Dict.values
            , selected = Nothing
            , onChange = \_ -> Msg.NoOp
            , toString = .name
            }
        ]
