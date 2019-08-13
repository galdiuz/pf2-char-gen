module Action.Background exposing (Action(..))

import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetBackground Data.Background
    | SetAbilityBoost Int Ability
