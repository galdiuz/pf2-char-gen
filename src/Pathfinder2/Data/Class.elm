module Pathfinder2.Data.Class exposing (..)

import Pathfinder2.Data.Ability as Ability exposing (Ability)


type alias Class =
    { name : String
    , hitPoints : Int
    , keyAbility : Ability.AbilityMod
    , skillFeats : List Int
    , skillIncreases : List Int
    }
