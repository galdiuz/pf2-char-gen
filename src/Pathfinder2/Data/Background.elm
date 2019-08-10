module Pathfinder2.Data.Background exposing (Background)

import Pathfinder2.Data.Ability as Ability exposing (Ability)


type alias Background =
    { name : String
    , abilityBoosts : List Ability.AbilityMod
    }