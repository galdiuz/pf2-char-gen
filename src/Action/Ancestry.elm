module Action.Ancestry exposing (Action(..))

import Pathfinder2.Data.Ability exposing (Ability)
import Pathfinder2.Data.Ancestry exposing (Ancestry)


type Action
    = NoOp
    | SetAncestry Ancestry
    | SetVoluntaryFlaw Bool
    | SetAbilityBoost Int Ability
    | SetAbilityFlaw Int Ability
