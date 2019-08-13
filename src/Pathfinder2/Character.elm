module Pathfinder2.Character exposing (..)

import Dict exposing (Dict)
import List.Extra
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Data.Background as Background exposing (Background)
import Pathfinder2.Data.Class exposing (Class)


type alias Character =
    { name : String
    , player : String
    , campaign : String
    , alignment : String
    , level : Int
    , experience : Int
    , baseAbilities : BaseAbilities
    , ancestry : Maybe Ancestry
    , ancestryOptions : AncestryOptions
    , background : Maybe Background
    , backgroundOptions : BackgroundOptions
    , class : Maybe Class
    , classOptions : ClassOptions
    , abilityBoosts: Dict Int (List Ability)
    }


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


type alias AncestryOptions =
    { abilityBoosts : Dict Int Ability
    , abilityFlaws : Dict Int Ability
    , voluntaryFlaw : Bool
    , heritage : Maybe String
    , languages : List String
    }


type alias BackgroundOptions =
    { abilityBoosts : Dict Int Ability
    }


type alias ClassOptions =
    { keyAbility : Maybe Ability
    }


emptyCharacter : Character
emptyCharacter =
    { name = ""
    , player = ""
    , campaign = ""
    , alignment = ""
    , level = 1
    , experience = 0
    , baseAbilities = Standard
    , ancestry = Nothing
    , ancestryOptions = emptyAncestryOptions
    , background = Nothing
    , backgroundOptions = emptyBackgroundOptions
    , class = Nothing
    , classOptions = emptyClassOptions
    , abilityBoosts = Dict.empty
    }


defaultAbilities : Abilities
defaultAbilities =
    { str = 10
    , dex = 10
    , con = 10
    , int = 10
    , wis = 10
    , cha = 10
    }


abilityValue : Ability -> (Abilities -> Int)
abilityValue ability =
    case ability of
        Ability.Str -> .str
        Ability.Dex -> .dex
        Ability.Con -> .con
        Ability.Int -> .int
        Ability.Wis -> .wis
        Ability.Cha -> .cha


emptyAncestryOptions : AncestryOptions
emptyAncestryOptions =
    { abilityBoosts = Dict.empty
    , abilityFlaws = Dict.empty
    , voluntaryFlaw = False
    , heritage = Nothing
    , languages = []
    }


emptyBackgroundOptions : BackgroundOptions
emptyBackgroundOptions =
    { abilityBoosts = Dict.empty
    }


emptyClassOptions : ClassOptions
emptyClassOptions =
    { keyAbility = Nothing
    }


ancestryAbilityBoosts : Character -> List Ability.AbilityMod
ancestryAbilityBoosts character =
    case (character.ancestry, character.ancestryOptions.voluntaryFlaw, character.baseAbilities) of
        (Nothing, _, _) ->
            []

        (Just ancestry, False, Standard) ->
            ancestry.abilityBoosts ++ [Ability.free]

        (Just ancestry, True, Standard) ->
            ancestry.abilityBoosts ++ [Ability.free, Ability.free]

        (Just ancestry, False, Rolled _) ->
            ancestry.abilityBoosts

        (Just ancestry, True, Rolled _) ->
            ancestry.abilityBoosts ++ [Ability.free]


ancestryAbilityFlaws : Character -> List Ability.AbilityMod
ancestryAbilityFlaws character =
    case (character.ancestry, character.ancestryOptions.voluntaryFlaw) of
        (Nothing, _) ->
            []

        (Just ancestry, False) ->
            ancestry.abilityFlaws

        (Just ancestry, True) ->
            ancestry.abilityFlaws ++ [Ability.free, Ability.free]


backgroundAbilityBoosts : Character -> List Ability.AbilityMod
backgroundAbilityBoosts character =
    case (character.background, character.baseAbilities) of
        (Nothing, _) ->
            []

        (Just background, Standard) ->
            background.abilityBoosts ++ [Ability.free]

        (Just background, Rolled _) ->
            background.abilityBoosts


abilities : Int -> Character -> Abilities
abilities level character =
    let
        base =
            case character.baseAbilities of
                Standard ->
                    defaultAbilities
                Rolled {str, dex, con, int, wis, cha} ->
                    { str = str
                    , dex = dex
                    , con = con
                    , int = int
                    , wis = wis
                    , cha = cha
                    }

        flaws =
            List.concat
                [ Maybe.map .abilityFlaws character.ancestry
                    |> Maybe.withDefault []
                    |> fixedAbilities
                , Dict.values character.ancestryOptions.abilityFlaws
                ]

        baseBoosts =
            List.concat
                [ Maybe.map .abilityBoosts character.ancestry
                    |> Maybe.withDefault []
                    |> fixedAbilities
                , Dict.values character.ancestryOptions.abilityBoosts
                , Dict.values character.backgroundOptions.abilityBoosts
                , Maybe.map .keyAbility character.class
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault []
                    |> fixedAbilities
                , case character.baseAbilities of
                    Standard ->
                        Maybe.map List.singleton character.classOptions.keyAbility
                            |> Maybe.withDefault []
                    Rolled _ ->
                        []
                , character.abilityBoosts
                    |> Dict.filter (\k _ -> k == 1)
                    |> Dict.values
                    |> List.concat
                ]

        boosts =
            character.abilityBoosts
                |> Dict.filter (\k _ -> k <= level && k > 1)
                |> Dict.values
                |> List.concat
    in
    base
        |> (\v -> List.foldl (addAbility (calcAbilityMod Remove Uncapped)) v flaws)
        |> (\v -> List.foldl (addAbility (calcAbilityMod Add Capped)) v baseBoosts)
        |> (\v -> List.foldl (addAbility (calcAbilityMod Add Uncapped)) v boosts)


type AbilityCap
    = Capped
    | Uncapped


type AbilityMod
    = Add
    | Remove


addAbility : (Int -> Int) -> Ability -> Abilities -> Abilities
addAbility calc ability totals =
    case ability of
        Ability.Str ->
            { totals | str = calc totals.str }
        Ability.Dex ->
            { totals | dex = calc totals.dex }
        Ability.Con ->
            { totals | con = calc totals.con }
        Ability.Int ->
            { totals | int = calc totals.int }
        Ability.Wis ->
            { totals | wis = calc totals.wis }
        Ability.Cha ->
            { totals | cha = calc totals.cha }


calcAbilityMod : AbilityMod -> AbilityCap -> Int -> Int
calcAbilityMod mod capped value =
    case (mod, capped) of
        (Add, Capped) ->
            min (value + 2) 18
        (Add, Uncapped) ->
            if value >= 18 then
                value + 1
            else
                value + 2
        (Remove, _) ->
            value - 2


fixedAbilities : List Ability.AbilityMod -> List Ability
fixedAbilities mods =
    List.filterMap
        (\abilityMod ->
            case abilityMod of
                Ability.Fixed ability ->
                    Just ability
                Ability.Choice _ ->
                    Nothing
        )
        mods


modValue : Int -> Int
modValue value =
    floor <| (toFloat value - 10) / 2
