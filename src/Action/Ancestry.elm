module Action.Ancestry exposing (Action(..))

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetAncestry (Data.Ancestry Ability.AbilityMod)
    | SetVoluntaryFlaw Bool
    | SetAbilityBoost Int Ability
    | SetAbilityFlaw Int Ability
    | SetHeritage Data.Heritage
