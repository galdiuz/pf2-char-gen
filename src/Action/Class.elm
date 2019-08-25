module Action.Class exposing (Action(..))

import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetClass Data.Class
    | SetSubclass String
    | SetKeyAbility Ability
