module UI.Layout exposing (box, scrollBox)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border


box : List (Element msg) -> Element msg
box inner =
    El.column
        [ Background.color <| El.rgb 0.9 0.9 0.9
        , Border.width 1
        , Border.rounded 2
        , El.padding 5
        , El.spacing 5
        , El.width El.fill
        , El.height El.fill
        ]
        inner


scrollBox : List (Element msg) -> Element msg
scrollBox inner =
    El.column
        [ Background.color <| El.rgb 0.9 0.9 0.9
        , Border.width 1
        , Border.rounded 2
        , El.padding 5
        , El.spacing 5
        , El.width El.fill
        , El.height El.fill
        , El.scrollbarY
        ]
        inner
