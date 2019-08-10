module Pathfinder2.Character exposing (..)

import Dict exposing (Dict)
import List.Extra
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Data.Background as Background exposing (Background)
import Pathfinder2.Data.Class exposing (Class)


type alias Character =
    { info : CharacterInfo
    , abilities : Abilities
    , ancestry : Maybe Ancestry
    , ancestryOptions : Maybe AncestryOptions
    , background : Maybe Background
    , backgroundOptions : Maybe BackgroundOptions
    , class : Maybe Class
    }


type alias CharacterInfo =
    { name : String
    , player : String
    , campaign : String
    , alignment : String
    , level : Int
    , experience : Int
    }


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


type Abilities
    = Standard
    | Rolled Int Int Int Int Int Int


emptyCharacter : Character
emptyCharacter =
    { info =
        { name = ""
        , player = ""
        , campaign = ""
        , alignment = ""
        , level = 1
        , experience = 0
        }
    , abilities = Standard
    , ancestry = Nothing
    , ancestryOptions = Nothing
    , background = Nothing
    , backgroundOptions = Nothing
    , class = Nothing
    }


emptyAncestryOptions : AncestryOptions
emptyAncestryOptions =
    { abilityBoosts = Dict.empty
    , abilityFlaws = Dict.empty
    , voluntaryFlaw = False
    , heritage = Nothing
    , languages = []
    }


ancestryOptions : Character -> AncestryOptions
ancestryOptions character =
    Maybe.withDefault emptyAncestryOptions character.ancestryOptions


ancestryAbilityBoosts : Character -> List Ability.AbilityMod
ancestryAbilityBoosts character =
    let
        voluntaryFlaw =
            Maybe.withDefault emptyAncestryOptions character.ancestryOptions
                |> .voluntaryFlaw
    in
    case (character.ancestry, voluntaryFlaw, character.abilities) of
        (Nothing, _, _) ->
            []

        (Just ancestry, False, Standard) ->
            ancestry.abilityBoosts ++ [Ability.free]

        (Just ancestry, True, Standard) ->
            ancestry.abilityBoosts ++ [Ability.free, Ability.free]

        (Just ancestry, False, Rolled _ _ _ _ _ _) ->
            ancestry.abilityBoosts

        (Just ancestry, True, Rolled _ _ _ _ _ _) ->
            ancestry.abilityBoosts ++ [Ability.free]


ancestryAbilityFlaws : Character -> List Ability.AbilityMod
ancestryAbilityFlaws character =
    let
        voluntaryFlaw =
            Maybe.withDefault emptyAncestryOptions character.ancestryOptions
                |> .voluntaryFlaw
    in
    case (character.ancestry, voluntaryFlaw) of
        (Nothing, _) ->
            []

        (Just ancestry, False) ->
            ancestry.abilityFlaws

        (Just ancestry, True) ->
            ancestry.abilityFlaws ++ [Ability.free, Ability.free]


emptyBackgroundOptions : BackgroundOptions
emptyBackgroundOptions =
    { abilityBoosts = Dict.empty
    }


backgroundOptions : Character -> BackgroundOptions
backgroundOptions character =
    Maybe.withDefault emptyBackgroundOptions character.backgroundOptions


backgroundAbilityBoosts : Character -> List Ability.AbilityMod
backgroundAbilityBoosts character =
    case (character.background, character.abilities) of
        (Nothing, _) ->
            []

        (Just background, Standard) ->
            background.abilityBoosts ++ [Ability.free]

        (Just background, Rolled _ _ _ _ _ _) ->
            background.abilityBoosts
