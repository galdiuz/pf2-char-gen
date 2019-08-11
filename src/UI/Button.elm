module UI.Button exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


type alias Config msg =
    { onPress : Maybe msg
    , label : Element msg
    }


render : Config msg -> Element msg
render config =
    Input.button
        [ Border.width 1
        , Border.rounded 2
        , El.padding 5
        , El.pointer
        , Background.color <| El.rgb 1 1 1
        ]
        config
