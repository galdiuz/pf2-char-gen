module App.Msg exposing (Msg(..), init)

import Browser
import Url

import App.View as View
import Action.Abilities as Abilities
import Action.Ancestry as Ancestry
import Action.Background as Background
import Action.Class as Class
import Action.Information as Information


type Msg
    = NoOp
    | NewUrlRequest Browser.UrlRequest
    | NewLocation Url.Url
    | SetView View.View
    | OpenModal View.View
    | CloseModal
    | Abilities Abilities.Action
    | Ancestry Ancestry.Action
    | Background Background.Action
    | Class Class.Action
    | Information Information.Action


init =
   {}
