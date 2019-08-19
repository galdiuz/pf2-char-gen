module View.Ancestry exposing (render)

import Dict exposing (Dict)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Font as Font

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import App.State as State exposing (State)
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
            [ UI.Text.header1 "Ancestry"
            , UI.ChooseOne.render
                { all = Dict.values state.data.ancestries
                , available = Dict.values state.data.ancestries
                , selected = state.character.ancestry
                , onChange = Msg.Ancestry << Ancestry.SetAncestry
                , toString = .name
                }
            ]
        ]
