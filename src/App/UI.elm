module App.UI exposing (render)

import Html exposing (Html)

import Element as El
import Element.Input as Input
import Element.Events as Events
import Element.Border as Border
import Element.Font as Font
import Element.Background as Background

import App.Msg as Msg exposing (Msg)
import App.View as View exposing (View)
import View.Ancestry as Ancestry
import View.Information as Information
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Character as Character exposing (Character)


type alias State s =
    { s
        | currentView : View
        , currentCharacter : Character
        , data : Data
    }


render : State s -> Html Msg
render state =
    El.layout
        [ Background.color <| El.rgb 0.95 0.95 0.95 ]
        <| El.row
            [ El.spacing 10
            , El.height El.fill
            ]
            [ renderNavigation state
            , renderContent state
            ]


renderNavigation state =
    El.column
        [ El.height El.fill
        , El.alignTop
        , El.padding 5
        , El.spacing 5
        , Border.widthEach
            { top = 0
            , bottom = 0
            , left = 0
            , right = 1
            }
        ]
        <| List.map
            (\item ->
                Input.button
                    [ El.width El.fill
                    , Border.width 1
                    , Border.rounded 10
                    , El.padding 5
                    ]
                    { onPress = Just item.msg
                    , label = El.el
                        [ Font.center
                        , El.height El.shrink
                        ]
                        <| El.text item.label
                    }
            )
            [ { msg = Msg.SetView View.Characters
              , label = "Characters"
              }
            , { msg = Msg.SetView View.Information
              , label = "Information"
              }
            , { msg = Msg.SetView View.Ancestry
              , label = "Ancestry"
              }
            ]


renderContent state =
    case state.currentView of
        View.Characters ->
            El.text "Chars"

        View.Information ->
            Information.render state

        View.Ancestry ->
            Ancestry.render state

        _ ->
            El.text "_"
