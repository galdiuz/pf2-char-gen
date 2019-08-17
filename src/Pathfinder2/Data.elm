module Pathfinder2.Data exposing (..)

import Dict exposing (Dict)

import Pathfinder2.Ability as Ability exposing (Ability)


type alias Data =
    { ancestries : Dict String Ancestry
    , backgrounds : Dict String Background
    , classes : Dict String Class
    , skills : Dict String Skill
    }


type alias Ancestry =
    { name : String
    , hitPoints : Int
    , size : String
    , speed : Int
    , abilityBoosts : List Ability.AbilityMod
    , abilityFlaws : List Ability.AbilityMod
    , languages : List String
    , traits : List String
    , heritages : List Heritage
    -- , feats : List Feat
    }


type alias Heritage =
    { name : String
    , description : String
    }


type alias Background =
    { name : String
    , abilityBoosts : List Ability.AbilityMod
    , skills : List String
    }


type alias Class =
    { name : String
    , hitPoints : Int
    , keyAbility : Ability.AbilityMod
    , skills : List String
    , skillIncreases : Int
    , skillFeatLevels : List Int
    , skillIncreaseLevels : List Int
    }


type alias Skill =
    { name : String
    , keyAbility : Ability
    }


type alias Feat =
    { name : String
    }


emptyData : Data
emptyData =
    { ancestries = Dict.empty
    , backgrounds = Dict.empty
    , classes = Dict.empty
    , skills = Dict.empty
    }


mergeData : Data -> Data -> Data
mergeData a b =
    { ancestries = Dict.union b.ancestries a.ancestries
    , backgrounds = Dict.union b.backgrounds a.backgrounds
    , classes = Dict.union b.classes a.classes
    , skills = Dict.union b.skills a.skills
    }
