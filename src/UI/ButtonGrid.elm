module UI.ButtonGrid exposing (renderChooseOne, renderChooseMany)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font


type alias ChooseOneConfig a msg =
    { items : List a
    --, available : List a
    , columns : List (a -> Element msg)
    , selected : Maybe a
    , onChange : a -> msg
    }


type alias ChooseManyConfig a msg =
    { items : List a
    --, available : List a
    , columns : List (a -> Element msg)
    , selected : List a
    , max : Int
    , onChange : List a -> msg
    }


type Position
    = First
    | Middle
    | Last


type Status
    = Selected
    | Selectable
    | Disabled


renderChooseOne : ChooseOneConfig a msg -> Element msg
renderChooseOne config =
    El.table
        [ El.spacingXY 0 5
        ]
        { data = config.items
        , columns =
            config.columns
                |> mapPosition
                |> mapColumnChooseOne config
        }


mapColumnChooseOne : ChooseOneConfig a msg -> List (Position, (a -> Element msg)) -> List (El.Column a msg)
mapColumnChooseOne config list =
    List.map
        (\(position, innerElement) ->
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
                        <| innerElement item
            }
        )
        list


renderChooseMany : ChooseManyConfig a msg -> Element msg
renderChooseMany config =
    El.table
        [ El.spacingXY 0 5
        ]
        { data = config.items
        , columns =
            config.columns
                |> mapPosition
                |> mapColumnChooseMany config
        }


mapColumnChooseMany : ChooseManyConfig a msg -> List (Position, (a -> Element msg)) -> List (El.Column a msg)
mapColumnChooseMany config list =
    List.map
        (\(position, innerElement) ->
            { header = El.none
            , width = El.shrink
            , view =
                \item ->
                    El.el
                        ( ( case "" of
                                Selected ->
                                    []
                                Selectable ->
                                    []
                                Disabled ->
                                    []
                          )
                          ++
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
                          , if List.member item config.selected then
                              Background.color <| El.rgb 0.8 0.8 1
                            else
                              El.pointer
                          -- , Events.onClick <| config.onChange item
                          ]
                        )
                        <| innerElement item
            }
        )
        list


attributes position status deselect =
    ( case status of
        Selected ->
            []
        Selectable ->
            [ El.pointer ]
        Disabled ->
            []
    )
    ++
    [ El.padding 5
    , El.height El.fill
    ]
    -- [ case position of
    --     First ->
    --         Border.widthEach
    --             { top = 1
    --             , bottom = 1
    --             , left = 1
    --             , right = 0
    --             }
    --     Middle ->
    --         Border.widthXY 0 1
    --     Last ->
    --         Border.widthEach
    --             { top = 1
    --             , bottom = 1
    --             , left = 0
    --             , right = 1
    --             }
    -- , El.pointer
    -- , Background.color <| El.rgb 1 1 1
    -- , if List.member item config.selected then
    --     Background.color <| El.rgb 0.8 0.8 1
    --   else
    --     El.pointer
    -- -- , Events.onClick <| config.onChange item
    -- ]


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
