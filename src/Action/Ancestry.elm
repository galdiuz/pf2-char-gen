module Action.Ancestry exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)


type Action
    = NoOp
    | SetAncestry String
    | SetAbilityBoost Int Ability
    | SetAbilityFlaw Int Ability
