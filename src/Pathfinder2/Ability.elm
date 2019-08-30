module Pathfinder2.Ability exposing
    ( Ability(..)
    , Abilities
    , BaseAbilities(..)
    , AbilityMod(..)
    , list
    , toString
    , fromString
    , decoder
    , modFromString
    , free
    , compare
    , defaultAbilities
    , fixedAbilityMods
    , calculatedAbilities
    , abilityValue
    , modifier
    )

import Json.Decode as Decode exposing (Decoder)


type Ability
    = Str
    | Dex
    | Con
    | Int
    | Wis
    | Cha


type alias Abilities =
    { str : Int
    , dex : Int
    , con : Int
    , int : Int
    , wis : Int
    , cha : Int
    }


type BaseAbilities
    = Standard
    | Rolled Abilities


type AbilityMod
    = Fixed Ability
    | Choice (List Ability)


type Operation
    = Add
    | Remove


list : List Ability
list =
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


decoder : Decoder Ability
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case fromString string of
                    Just ability ->
                        Decode.succeed ability
                    Nothing ->
                        Decode.fail <| "Unknown ability '" ++ string ++ "'"
            )


modFromString : String -> Maybe AbilityMod
modFromString string =
    if string == "Free" then
        Just free
    else
        Maybe.map Fixed <| fromString string


free : AbilityMod
free =
    Choice [ Str, Dex, Con, Int, Wis, Cha ]


compare : Ability -> Ability -> Order
compare a b =
    if a == b then
        EQ
    else if a == Str && List.member b [Dex, Con, Int, Wis, Cha] then
        LT
    else if a == Dex && List.member b [Con, Int, Wis, Cha] then
        LT
    else if a == Con && List.member b [Int, Wis, Cha] then
        LT
    else if a == Int && List.member b [Wis, Cha] then
        LT
    else if a == Wis && b == Cha then
        LT
    else
        GT


fixedAbilityMods : List AbilityMod -> List Ability
fixedAbilityMods mods =
    List.filterMap
        (\abilityMod ->
            case abilityMod of
                Fixed ability ->
                    Just ability
                Choice _ ->
                    Nothing
        )
        mods


defaultAbilities : Abilities
defaultAbilities =
    { str = 10
    , dex = 10
    , con = 10
    , int = 10
    , wis = 10
    , cha = 10
    }


calculatedAbilities : BaseAbilities -> List Ability -> List Ability -> List Ability -> Abilities
calculatedAbilities base flaws cappedBoosts uncappedBoosts =
    ( case base of
        Standard ->
            defaultAbilities
        Rolled abilities ->
            abilities
    )
        |> (\v -> List.foldl (addAbility <| applyAbilityMod Remove True) v flaws)
        |> (\v -> List.foldl (addAbility <| applyAbilityMod Add True) v cappedBoosts)
        |> (\v -> List.foldl (addAbility <| applyAbilityMod Add False) v uncappedBoosts)


addAbility : (Int -> Int) -> Ability -> Abilities -> Abilities
addAbility fun ability totals =
    case ability of
        Str ->
            { totals | str = fun totals.str }
        Dex ->
            { totals | dex = fun totals.dex }
        Con ->
            { totals | con = fun totals.con }
        Int ->
            { totals | int = fun totals.int }
        Wis ->
            { totals | wis = fun totals.wis }
        Cha ->
            { totals | cha = fun totals.cha }


applyAbilityMod : Operation -> Bool -> Int -> Int
applyAbilityMod operation capped value =
    case (operation, capped) of
        (Add, True) ->
            min (value + 2) 18
        (Add, False) ->
            if value >= 18 then
                value + 1
            else
                value + 2
        (Remove, _) ->
            value - 2


abilityValue : Ability -> (Abilities -> Int)
abilityValue ability =
    case ability of
        Str -> .str
        Dex -> .dex
        Con -> .con
        Int -> .int
        Wis -> .wis
        Cha -> .cha


modifier : Int -> Int
modifier value =
    floor <| (toFloat value - 10) / 2
