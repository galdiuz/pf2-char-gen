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


compare : Ability -> Ability -> Order
compare a b =
    if a == Str && List.member b [Dex, Con, Int, Wis, Cha] then
        LT
    else if a == Dex && List.member b [Con, Int, Wis, Cha] then
        LT
    else if a == Con && List.member b [Int, Wis, Cha] then
        LT
    else if a == Int && List.member b [Wis, Cha] then
        LT
    else if a == Wis && List.member b [Cha] then
        LT
    else
        GT
