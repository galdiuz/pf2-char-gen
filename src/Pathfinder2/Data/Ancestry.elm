module Pathfinder2.Data.Ancestry exposing (..)

-- import Pathfinder2.Data.Language
import Pathfinder2.Data.Ability as Ability


type alias Ancestry =
    { name : String
    , hitPoints : Int
    , size : String
    , speed : Int
    , abilityBoosts : List Ability.AbilityMod
    , abilityFlaws : List Ability.AbilityMod
    , languages : List Language
    , traits : List String
    , heritages : List Heritage
    , feats : List Feat
    }


type alias Heritage =
    { name : String
    , description : String
    }


type alias Feat =
    { name : String
    , level : Int
    , description : String
    }


type alias Language = String
