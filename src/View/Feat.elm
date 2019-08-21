module View.Feat exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Border as Border

import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Pathfinder2.Data as Data
import UI.ButtonGrid
import UI.Layout
import UI.Text


render : State -> Int -> String -> Element Msg
render state level tag =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.height El.fill
        , El.scrollbarY
        , El.spacing 10
        ]
        [ El.el
            [ El.width El.fill
            ]
            <| UI.Layout.box
                [ El.text "Search"
                ]
        , El.el
            [ El.height <| El.fill
            , El.scrollbarY
            ]
            <| UI.Layout.scrollBox
                [ renderList state level tag
                ]
        ]


renderList : State -> Int -> String -> Element Msg
renderList state level tag =
    UI.ButtonGrid.renderChooseOne
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
        , columns =
            [ \feat ->
                El.column
                    [ El.spacing 5
                    ]
                    [ UI.Text.header3 feat.name
                    , El.row
                        [ El.spacing 5
                        ]
                        <| List.map
                            ( El.el
                                [ Border.width 1
                                , El.padding 2
                                ]
                                << El.text
                            )
                            feat.tags
                    ]
            , \feat ->
                El.el
                    [ El.alignRight
                    , El.centerY
                    , El.padding 5
                    , Border.width 1
                    ]
                    <| El.text <| String.fromInt <| feat.level
            ]
        }
