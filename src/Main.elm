module Main exposing (main)

import Browser

import App
import App.Flags exposing (Flags)
import App.Msg as Msg exposing (Msg)
import App.State exposing (State)
import App.Update as Update


main : Program Flags State Msg
main =
    Browser.application
        { init = App.init
        , view = App.render
        , update = Update.update
        , subscriptions = App.subscriptions
        , onUrlRequest = Msg.NewUrlRequest
        , onUrlChange = Msg.NewLocation
        }
