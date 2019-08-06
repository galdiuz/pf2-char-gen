module Pathfinder2.Character exposing (..)

import Dict exposing (Dict)
import List.Extra
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Data.Class exposing (Class)


type alias Character =
    { info : CharacterInfo
    , ancestry : CharacterAncestry
    -- background : Background
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


type alias CharacterAncestry =
    { ancestry : Maybe Ancestry
    , options : Maybe AncestryOptions
    }


type alias AncestryOptions =
    { abilityBoosts : Dict Int Ancestry.Ability
    , abilityFlaws : Dict Int Ancestry.Ability
    , heritage : Maybe String
    , languages : List String
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


getAbilityBoosts : Character -> List Ancestry.AbilityMod
getAbilityBoosts character =
    case (character.ancestry.ancestry, character.info.abilities) of
        (Nothing, _) ->
            []
        (Just ancestry, Standard) ->
            ancestry.abilityBoosts
        (Just ancestry, VoluntaryFlaw) ->
            ancestry.abilityBoosts ++ [Ancestry.Free]
        (Just ancestry, Rolled _ _ _ _ _ _) ->
            Maybe.withDefault [] <| List.Extra.init ancestry.abilityBoosts


getAbilityFlaws : Character -> List Ancestry.AbilityMod
getAbilityFlaws character =
    case (character.ancestry.ancestry, character.info.abilities) of
        (Nothing, _) ->
            []
        (Just ancestry, Standard) ->
            ancestry.abilityFlaws
        (Just ancestry, VoluntaryFlaw) ->
            ancestry.abilityFlaws ++ [Ancestry.Free, Ancestry.Free]
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
        , abilities = Standard
        }
    , class =
        { name = "Monk"
        }
    , ancestry =
        { ancestry = Nothing
        , options = Nothing
        }
    }


