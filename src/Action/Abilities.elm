module Action.Abilities exposing (Action(..))

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character


type Action
    = NoOp
    | SetBaseAbilities String
    | SetBaseAbility Ability.Abilities Ability String
    | SetAbilityBoosts Int (List Ability)
