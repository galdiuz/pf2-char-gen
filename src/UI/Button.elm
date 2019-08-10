module UI.Button exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input


type alias Config msg =
    { onClick : msg
    , text : String
    }


render : Config msg -> Element msg
render config =
    El.el
        [ Border.width 1
        , El.padding 5
        , El.pointer
        , Events.onClick config.onClick
        , Background.color <| El.rgb 1 1 1
        , Border.rounded 2
        ]
        <| El.text config.text
