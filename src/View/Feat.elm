module View.Feat exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Border as Border

import Action.Feat as Feat
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import Fun
import Pathfinder2.Data as Data
import UI.ButtonGrid
import UI.Layout
import UI.Text


render : State -> Int -> String -> String -> Element Msg
render state level key trait =
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
                [ renderList state key trait
                ]
        ]


renderList : State -> String -> String -> Element Msg
renderList state key trait =
    UI.ButtonGrid.renderChooseOne
        { all =
            state.data.feats
                |> Data.filterFeatsByTrait trait
                |> Dict.values
                |> Fun.sortWith (Fun.compare .level) [ Fun.compare .name ]
        , available =
            state.data.feats
                |> Data.filterFeatsByTrait trait
                |> Dict.values
        , selected =
            state.character.feats
                |> Dict.get key
        , onChange = Msg.Feat << Feat.SetFeat key
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
                            feat.traits
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
