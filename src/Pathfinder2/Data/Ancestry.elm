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


allAbilities : List Ability
allAbilities =
    [ Str
    , Dex
    , Con
    , Int
    , Wis
    , Cha
    ]


abilityToString : Ability -> String
abilityToString ability =
    case ability of
        Str -> "Strength"
        Dex -> "Dexterity"
        Con -> "Constitution"
        Int -> "Intelligence"
        Wis -> "Wisdom"
        Cha -> "Charisma"


abilityFromString : String -> Maybe Ability
abilityFromString string =
    case string of
        "Str" -> Just Str
        "Dex" -> Just Dex
        "Con" -> Just Con
        "Int" -> Just Int
        "Wis" -> Just Wis
        "Cha" -> Just Cha
        _ -> Nothing


abilityModFromString : String -> Maybe AbilityMod
abilityModFromString string =
    if string == "Free" then
        Just Free
    else
        Maybe.map Ability <| abilityFromString string


type AbilityMod
    = Ability Ability
    | Free


type alias Language = String
