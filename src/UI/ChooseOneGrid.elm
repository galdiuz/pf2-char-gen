module UI.ChooseOneGrid exposing (render)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font


type alias Config a msg =
    { items : List a
    , columns : List (a -> Element msg)
    , selected : Maybe a
    , onChange : a -> msg
    }


type Position
    = First
    | Middle
    | Last


render : Config a msg -> Element msg
render config =
    El.table
        [ El.spacingXY 0 5
        ]
        { data = config.items
        , columns =
            config.columns
                |> mapPosition
                |> mapColumn config
        }


mapColumn : Config a msg -> List (Position, (a -> Element msg)) -> List (El.Column a msg)
mapColumn config list =
    List.map
        (\(position, el) ->
            { header = El.none
            , width = El.shrink
            , view =
                \item ->
                    El.el
                        [ case position of
                            First ->
                                Border.widthEach
                                    { top = 1
                                    , bottom = 1
                                    , left = 1
                                    , right = 0
                                    }
                            Middle ->
                                Border.widthXY 0 1
                            Last ->
                                Border.widthEach
                                    { top = 1
                                    , bottom = 1
                                    , left = 0
                                    , right = 1
                                    }
                        , El.padding 5
                        , El.height El.fill
                        , El.pointer
                        , Background.color <| El.rgb 1 1 1
                        , if config.selected == Just item then
                            Background.color <| El.rgb 0.8 0.8 1
                          else
                            El.pointer
                        , Events.onClick <| config.onChange item
                        ]
                        <| el item
            }
        )
        list


mapPosition : List a -> List (Position, a)
mapPosition list =
    List.indexedMap
        (\idx item ->
            if idx == 0 then
                (First, item)
            else if idx == (List.length list) - 1 then
                (Last, item)
            else
                (Middle, item)
        )
        list
