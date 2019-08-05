module App.Msg exposing (Msg(..), init, noCmd)

import Browser
import Url

import App.View as View
import Action.Ancestry as Ancestry
import Action.Information as Information


type Msg
    = NoOp
    | NewUrlRequest Browser.UrlRequest
    | NewLocation Url.Url
    | SetView View.View
    | Ancestry Ancestry.Action
    | Information Information.Action


init =
    {}


noCmd : state -> ( state, Cmd Msg )
noCmd state =
    ( state, Cmd.none )
