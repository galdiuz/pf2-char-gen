module Pathfinder2.Data.Ancestry exposing (..)

-- import Pathfinder2.Data.Language


type alias Ancestry =
    { name : String
    , hitpoints : Int
    , size : String
    , speed : Int
    , abilityBoosts : List AbilityMod
    , abilityFlaws : List AbilityMod
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


type Ability
    = Str
    | Dex
    | Con
    | Int
    | Wis
    | Cha


type AbilityMod
    = Increase Ability
    | Decrease Ability


type AbilityBoost
    = Ability
    | Free


type alias Language = String
