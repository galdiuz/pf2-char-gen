module UI.Text exposing (header1, header2, header3, label)

import Element as El exposing (Element)
import Element.Font as Font


header1 : String -> Element msg
header1 text =
    El.el
        [ Font.bold
        , Font.size 28
        ]
        <| El.text text


header2 : String -> Element msg
header2 text =
    El.el
        [ Font.bold
        , Font.size 24
        ]
        <| El.text text


header3 : String -> Element msg
header3 text =
    El.el
        [ Font.bold
        , Font.size 20
        ]
        <| El.text text


label : String -> Element msg
label text =
    El.el
        [ Font.size 18
        , Font.italic
        ]
        <| El.text text
