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
import View.Feat as Feat
import View.Heritage as Heritage
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
            , El.height <| El.px state.window.height
            , El.clipY
            ]
            state.modals
            state
        )
        <| El.row
            [ El.width El.fill
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
    El.el
        [ El.scrollbarY
        , El.padding 5
        , El.width El.fill
        , El.height <| El.px state.window.height
        ]
        <| renderView view state


renderView : View -> State -> Element Msg
renderView view state =
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

        View.Heritage ->
            Heritage.render state

        View.Skill level picks ->
            Skill.render state level picks

        View.Feat level tags ->
            Feat.render state level tags


withModals : List (El.Attribute Msg) -> List View -> State -> List (El.Attribute Msg)
withModals attributes views state =
    if List.isEmpty views then
        attributes
    else
        attributes
        ++
        [ El.inFront
            <| El.el
                [ El.width El.fill
                , El.height El.fill
                , Background.color <| El.rgba 0 0 0 0.5
                ]
                El.none
        ]
        ++
        List.indexedMap
            (\idx view ->
                El.inFront
                    <| El.el
                        [ El.padding 10
                        , El.width El.fill
                        , El.height El.fill
                        ]
                        <| El.column
                            [ El.padding 10
                            , El.spacing 10
                            , Background.color <| El.rgb 0.8 0.8 0.8
                            , Border.width 1
                            , Border.rounded 2
                            , El.centerX
                            , El.centerY
                            , El.height
                                <| El.maximum (state.window.height - 20)
                                <| El.shrink
                            , El.inFront
                                ( if idx /= List.length views - 1 then
                                    El.el
                                        [ El.width El.fill
                                        , El.height El.fill
                                        , Background.color <| El.rgba 0 0 0 0.5
                                        , Border.rounded 1
                                        ]
                                        El.none
                                else
                                    El.none
                                )
                            ]
                            [ El.el
                                [ El.clip
                                , El.height
                                    <| El.maximum (state.window.height - 82)
                                    <| El.fill
                                ]
                                <| renderView view state
                            , El.el
                                [ El.centerX
                                ]
                                <| UI.Button.render
                                    { onPress = Just Msg.CloseModal
                                    , label = El.text "Close"
                                    }
                            ]
            )
            (List.reverse views)
