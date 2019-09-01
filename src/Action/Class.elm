module Action.Class exposing (Action(..))

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetClass (Data.Class Ability.AbilityMod (Data.Skill Ability))
    | SetSubclass String
    | SetKeyAbility Ability
