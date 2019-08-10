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


toString : Ability -> String
toString ability =
    case ability of
        Str -> "Strength"
        Dex -> "Dexterity"
        Con -> "Constitution"
        Int -> "Intelligence"
        Wis -> "Wisdom"
        Cha -> "Charisma"


fromString : String -> Maybe Ability
fromString string =
    case string of
        "Str" -> Just Str
        "Dex" -> Just Dex
        "Con" -> Just Con
        "Int" -> Just Int
        "Wis" -> Just Wis
        "Cha" -> Just Cha
        _ -> Nothing


modFromString : String -> Maybe AbilityMod
modFromString string =
    if string == "Free" then
        Just free
    else
        Maybe.map Fixed <| fromString string


free : AbilityMod
free =
    Choice [ Str, Dex, Con, Int, Wis, Cha ]


type AbilityMod
    = Fixed Ability
    | Choice (List Ability)
