module Action.Class exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)
import Pathfinder2.Data.Class exposing (Class)


type Action
    = NoOp
    | SetClass Class
    | SetKeyAbility Ability
