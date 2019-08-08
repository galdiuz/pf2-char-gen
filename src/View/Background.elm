module View.Background exposing (render)

import Dict

import Element as El exposing (Element)
import Element.Border as Border
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import App.Msg as Msg exposing (Msg)
import Pathfinder2.Data.Background as Background exposing (Background)
import App.State exposing (State)


render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        ]
        <| List.filterMap identity
            [ renderBackgroundChoice state
            , renderBackgroundOptions state
            ]


renderBackgroundChoice : State -> Maybe (Element Msg)
renderBackgroundChoice state =
    Just <| El.column
        [ El.spacing 5
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Background"
        , El.wrappedRow
            [ El.spacing 5 ]
            <| List.map
                renderBackgroundChoiceButton
            <| Dict.toList state.data.backgrounds

            -- { onChange = \_ -> Msg.NoOp
            -- , options =
            --     state.data.backgrounds
            --         |> Dict.toList
            --         |> List.map
            --             (\(key, background) ->
            --                 Input.optionWith key (renderBackground background)
            --             )
            -- , selected = Nothing
            -- , label = Input.labelHidden ""
            -- }
        -- , Input.radioRow
        --     [ El.spacing 5
        --     , El.paddingXY 0 10
        --     ]
        --     { onChange = \_ -> Msg.NoOp
        --     , options =
        --         state.data.backgrounds
        --             |> Dict.toList
        --             |> List.map
        --                 (\(key, background) ->
        --                     Input.optionWith key (renderBackground background)
        --                 )
        --     , selected = Nothing
        --     , label = Input.labelHidden ""
        --     }
        ]


renderBackgroundChoiceButton (key, background) =
    let
        activeStyle =
            [ Border.width 1
            , El.padding 5
            , Events.onClick Msg.NoOp
            , El.pointer
            ]

        selectedStyle =
            [ Border.width 2
            , El.padding 4
            , Background.color <| El.rgb 0.8 0.8 0.8
            ]
    in
    El.el
        activeStyle
        <| El.text background.name


renderBackground : Background -> Input.OptionState -> Element Msg
renderBackground background optionState =
    let
        style =
            case optionState of
                Input.Selected ->
                    [ Border.width 2
                    , El.padding 4
                    , Background.color <| El.rgb 0.8 0.8 0.8
                    ]

                _ ->
                    [ Border.width 1
                    , El.padding 5
                    ]
    in
        El.el style <| El.text background.name


renderBackgroundOptions : State -> Maybe (Element Msg)
renderBackgroundOptions state =
    Nothing
