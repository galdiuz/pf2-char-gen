module UI.ChooseMany exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import List.Extra


type alias Config a msg =
    { all : List a
    , selected : List a
    , max : Int
    , onChange : List a -> msg
    , toString : a -> String
    }


render : Config a msg -> Element msg
render config =
    El.column
        [ El.spacing 5 ]
        [ El.text
            ( "Select "
            ++ (String.fromInt <| config.max)
            ++ " (Remaining: "
            ++ (String.fromInt <| config.max - List.length config.selected)
            ++ ")"
            )
        , El.wrappedRow
            [ El.spacing 2 ]
            <| List.map (renderButton config) config.all
        ]


renderButton : Config a msg -> a -> Element msg
renderButton config value =
    let
        activeStyle =
            [ Border.width 1
            , Border.rounded 2
            , El.padding 5
            , El.pointer
            , Events.onClick <| config.onChange <| value :: config.selected
            , Background.color <| El.rgb 1 1 1
            ]

        selectedStyle =
            [ Border.width 2
            , Border.rounded 2
            , El.padding 4
            , El.pointer
            , Events.onClick <| config.onChange <| List.Extra.remove value config.selected
            , Background.color <| El.rgb 1 1 0.8
            ]

        inactiveStyle =
            [ Border.color <| El.rgb 0.5 0.5 0.5
            , Border.dashed
            , Border.rounded 2
            , Border.width 1
            , El.padding 5
            , Font.color <| El.rgb 0.5 0.5 0.5
            ]

        style =
            if List.member value config.selected then
                selectedStyle
            else if List.length config.selected < config.max then
                activeStyle
            else
                inactiveStyle
    in
    El.el
        style
        <| El.text <| config.toString value
