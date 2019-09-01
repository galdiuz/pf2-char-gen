module Action.Class exposing (Action(..))

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetClass (Data.Class Ability Ability.AbilityMod)
    | SetSubclass String
    | SetKeyAbility Ability
