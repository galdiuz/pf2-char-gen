module View.Heritage exposing (render)

import Element as El exposing (Element)
import Element.Font as Font

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import UI.ChooseOne

render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Select Heritage"
        , UI.ChooseOne.render
            { all =
                state.character.ancestry
                    |> Maybe.map .heritages
                    |> Maybe.withDefault []
            , available =
                state.character.ancestry
                    |> Maybe.map .heritages
                    |> Maybe.withDefault []
            , selected = state.character.ancestryOptions.heritage
            , onChange = Msg.Ancestry << Ancestry.SetHeritage
            , toString = .name
            }
        ]
