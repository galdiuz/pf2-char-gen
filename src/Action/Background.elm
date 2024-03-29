module Action.Background exposing (Action(..))

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetBackground (Data.Background Ability.AbilityMod (Data.Skill Ability))
    | SetAbilityBoost Int Ability
