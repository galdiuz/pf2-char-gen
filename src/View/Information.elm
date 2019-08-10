module View.Information exposing (render)

import Element as El exposing (Element)
import Element.Events as Events
import Element.Input as Input

import App.Msg as Msg exposing (Msg)
import Action.Information as Action
import Pathfinder2.Character as Character exposing (Character)


type alias State s =
    { s | character : Character }


render : State s -> Element Msg
render state =
    El.table
        [ El.alignTop ]
        { data = inputs state
        , columns =
            [ { header = El.text ""
              , width = El.px 150
              , view = \row ->
                    El.el
                        [ El.centerY ]
                        <| El.text row.label
              }
            , { header = El.text ""
              , width = El.fill
              , view = \row -> row.input
              }
            ]
        }


inputs state =
    [ { label = "Name"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.character.info.name
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    , { label = "Player"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.character.info.player
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    , { label = "Campaign"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.character.info.player
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    ]
