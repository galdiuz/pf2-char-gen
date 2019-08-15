module App.UI exposing (render)

import Html exposing (Html)

import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import List.Extra

import App.State exposing (State)
import App.Msg as Msg exposing (Msg)
import App.View as View exposing (View)
import View.Abilities as Abilities
import View.Ancestry as Ancestry
import View.Background as Background
import View.Build as Build
import View.Class as Class
import View.Information as Information
import View.Skill as Skill
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Character as Character exposing (Character)
import UI.Button


render : State -> Html Msg
render state =
    El.layout
        ( withModals
            [ Background.color <| El.rgb 0.8 0.8 0.8
            ]
            (List.reverse state.modals)
            state
        )
        <| El.row
            [ El.spacing 10
            , El.height El.fill
            ]
            [ renderNavigation state
            , renderContent state.currentView state
            ]


renderNavigation : State -> Element Msg
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
                    , Background.color <| El.rgb 1 1 1
                    ]
                    { onPress = Just item.msg
                    , label = El.el
                        [ Font.center
                        , El.height El.shrink
                        , El.width El.fill
                        ]
                        <| El.text item.label
                    }
            )
            [ { msg = Msg.SetView View.Build
              , label = "Build"
              }
            , { msg = Msg.SetView View.Information
              , label = "Information"
              }
            ]


renderContent : View -> State -> Element Msg
renderContent view state =
    case view of
        View.Build ->
            Build.render state

        View.Information ->
            Information.render state

        View.Ancestry ->
            Ancestry.render state

        View.Background ->
            Background.render state

        View.Class ->
            Class.render state

        View.Abilities ->
            Abilities.render state

        View.AbilityBoosts level ->
            Abilities.render2 state level

        View.Skill level picks ->
            Skill.render state level picks


withModals : List (El.Attribute Msg) -> List View -> State -> List (El.Attribute Msg)
withModals attributes views state =
    case List.Extra.uncons views of
        Nothing ->
            attributes
        Just ( view, remaining ) ->
            attributes
            ++
            [ El.inFront <| renderModal view remaining state
            ]


renderModal : View -> List View -> State -> Element Msg
renderModal view remaining state =
    El.el
        [ El.width El.fill
        , El.height El.fill
        , El.padding 50
        , Background.color <| El.rgba 0 0 0 0.5
        , El.inFront
            <| El.el
                ( withModals
                    [ El.padding 10
                    , Background.color <| El.rgb 0.8 0.8 0.8
                    , Border.width 1
                    , Border.rounded 2
                    , El.centerX
                    ]
                    remaining
                    state
                )
                <| El.column
                    [ El.spacing 20
                    ]
                    [ renderContent view state
                    , El.el
                        [ El.centerX ]
                        <| UI.Button.render
                            { onPress = Just Msg.CloseModal
                            , label = El.text "Close"
                            }
                    ]
        ]
        El.none
