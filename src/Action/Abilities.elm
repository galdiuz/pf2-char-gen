module Action.Abilities exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)


type Action
    = NoOp
    | SetAbilityBoosts (List Ability)
