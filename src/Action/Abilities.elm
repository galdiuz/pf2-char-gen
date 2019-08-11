module Action.Abilities exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)
import Pathfinder2.Character as Character


type Action
    = NoOp
    | SetBaseAbilities String
    | SetBaseAbility Character.Abilities Ability String
    | SetAbilityBoosts (List Ability)
