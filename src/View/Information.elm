module View.Information exposing (render)

import Element exposing (Element, el, text, row, column, table)
import Element.Events as Events
import Element.Input as Input

import App.Msg as Msg exposing (Msg)
import Action.Information as Action
import Pathfinder2.Character as Character exposing (Character)


type alias State s =
    { s | currentCharacter : Character }


render : State s -> Element Msg
render state =
    table
        []
        { data = inputs state
        , columns =
            [ { header = text ""
              , width = Element.px 150
              , view = \row ->
                    el
                        [ Element.centerY ]
                        <| text row.label
              }
            , { header = text ""
              , width = Element.fill
              , view = \row -> row.input
              }
            ]
        }


inputs state =
    [ { label = "Name"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.currentCharacter.info.name
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    , { label = "Player"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.currentCharacter.info.player
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    , { label = "Campaign"
      , input = Input.text
        []
        { onChange = \value -> Msg.Information <| Action.SetName value
        , text = state.currentCharacter.info.player
        , placeholder = Nothing
        , label = Input.labelHidden ""
        }
      }
    ]
