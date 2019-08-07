module Pathfinder2.Data.Ability exposing (..)


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
