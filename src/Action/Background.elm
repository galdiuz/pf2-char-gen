module Action.Background exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)
import Pathfinder2.Data.Background exposing (Background)


type Action
    = NoOp
    | SetBackground Background
    | SetAbilityBoost Int Ability
