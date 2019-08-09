module Pathfinder2.Character exposing (..)

import Dict exposing (Dict)
import List.Extra
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Data.Background as Background exposing (Background)
import Pathfinder2.Data.Class exposing (Class)


type alias Character =
    { info : CharacterInfo
    , ancestry : Maybe Ancestry
    , ancestryOptions : Maybe AncestryOptions
    , background : Maybe Background
    , backgroundOptions : Maybe BackgroundOptions
    , class : Class
    --, abilities : Abilities
    }


type alias CharacterInfo =
    { name : String
    , player : String
    , campaign : String
    , alignment : String
    , level : Int
    , experience : Int
    , abilities : Abilities
    }


type alias AncestryOptions =
    { abilityBoosts : Dict Int Ability
    , abilityFlaws : Dict Int Ability
    , heritage : Maybe String
    , languages : List String
    }


type alias BackgroundOptions =
    { abilityBoosts : Dict Int Ability
    }


emptyAncestryOptions : AncestryOptions
emptyAncestryOptions =
    { abilityBoosts = Dict.empty
    , abilityFlaws = Dict.empty
    , heritage = Nothing
    , languages = []
    }


type Abilities
    = Standard
    | VoluntaryFlaw
    | Rolled Int Int Int Int Int Int


ancestryAbilityBoosts : Character -> List Ability.AbilityMod
ancestryAbilityBoosts character =
    case (character.ancestry, character.info.abilities) of
        (Nothing, _) ->
            []
        (Just ancestry, Standard) ->
            ancestry.abilityBoosts
        (Just ancestry, VoluntaryFlaw) ->
            ancestry.abilityBoosts ++ [Ability.Free]
        (Just ancestry, Rolled _ _ _ _ _ _) ->
            Maybe.withDefault [] <| List.Extra.init ancestry.abilityBoosts


ancestryAbilityFlaws : Character -> List Ability.AbilityMod
ancestryAbilityFlaws character =
    case (character.ancestry, character.info.abilities) of
        (Nothing, _) ->
            []
        (Just ancestry, Standard) ->
            ancestry.abilityFlaws
        (Just ancestry, VoluntaryFlaw) ->
            ancestry.abilityFlaws ++ [Ability.Free, Ability.Free]
        (Just ancestry, Rolled _ _ _ _ _ _) ->
            ancestry.abilityFlaws


--emptyCharacter : Character
emptyCharacter =
    { info =
        { name = ""
        , player = ""
        , campaign = ""
        , alignment = ""
        , level = 1
        , experience = 0
        , abilities = Standard
        }
    , ancestry =
        { name = ""
        }
    , class =
        { name = ""
        }
    }


--testCharacter : Character
testCharacter =
    { info =
        { name = "Monk Dude"
        , player = "Galdiuz"
        , campaign = ""
        , alignment = "NG"
        , level = 3
        , experience = 0
        , abilities = VoluntaryFlaw
        }
    , class =
        { name = "Monk"
        }
    , ancestry = Nothing
    , ancestryOptions = Nothing
    , background = Nothing
    , backgroundOptions = Nothing
    }
