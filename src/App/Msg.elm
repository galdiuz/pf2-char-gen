module App.Msg exposing (Msg(..), init)

import Browser
import Url

import App.View as View
import Action.Abilities as Abilities
import Action.Ancestry as Ancestry
import Action.Background as Background
import Action.Class as Class
import Action.Information as Information
import Action.Skill as Skill
import Action.Feat as Feat


type Msg
    = NoOp
    | NewUrlRequest Browser.UrlRequest
    | NewLocation Url.Url
    | OnResize Int Int
    | SetView View.View
    | OpenModal View.View
    | CloseModal
    | Abilities Abilities.Action
    | Ancestry Ancestry.Action
    | Background Background.Action
    | Class Class.Action
    | Information Information.Action
    | Skill Skill.Action
    | Feat Feat.Action


init =
   {}
