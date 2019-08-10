module UI.ChooseOne exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input


type alias Config a msg =
    { all : List a
    , available : List a
    , selected : Maybe a
    , onChange : a -> msg
    , toString : a -> String
    }


render : Config a msg -> Element msg
render config =
    El.wrappedRow
        [ El.spacing 5 ]
        <| List.map (renderButton config) config.all


renderButton : Config a msg -> a -> Element msg
renderButton config value =
    let
        activeStyle =
            [ Border.width 1
            , Border.rounded 2
            , El.padding 5
            , El.pointer
            , Events.onClick <| config.onChange value
            , Background.color <| El.rgb 1 1 1
            ]

        selectedStyle =
            [ Border.width 2
            , Border.rounded 2
            , El.padding 4
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
            if config.selected == Just value then
                selectedStyle
            else if List.member value config.available then
                activeStyle
            else
                inactiveStyle
    in
    El.el
        style
        <| El.text <| config.toString value
