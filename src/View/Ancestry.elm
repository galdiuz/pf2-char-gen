module View.Ancestry exposing (render)

import Dict exposing (Dict)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Font as Font

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import App.State as State exposing (State)
import UI.ChooseOne


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 5
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Ancestry"
        , UI.ChooseOne.render
            { all = Dict.values state.data.ancestries
            , available = Dict.values state.data.ancestries
            , selected = state.character.ancestry
            , onChange = Msg.Ancestry << Ancestry.SetAncestry
            , toString = .name
            }
        ]
