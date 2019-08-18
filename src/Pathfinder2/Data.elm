module Pathfinder2.Data exposing (..)

import Dict exposing (Dict)

import Maybe.Extra

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
    }


type alias Heritage =
    { name : String
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
    , level : Int
    , prereqs : List String
    , tags: List String
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


skills : Data -> Dict String Skill
skills data =
    Dict.union
        data.skills
        ( data.backgrounds
            |> Dict.values
            |> List.map .skills
            |> List.concat
            |> List.filterMap ( getSkill data.skills )
            |> List.map (\s -> (s.name, s))
            |> Dict.fromList
        )


compareSkills : Skill -> Skill -> Order
compareSkills a b =
    case (isLore a, isLore b) of
        (True, True) ->
            compare a.name b.name
        (True, False) ->
            GT
        (False, True) ->
            LT
        (False, False) ->
            compare a.name b.name


isLore : Skill -> Bool
isLore skill =
    String.endsWith "Lore" skill.name


loreSkills : Dict String Skill -> Dict String Skill
loreSkills dict =
    Dict.filter
        (\k _ ->
            String.endsWith "Lore" k
        )
        dict


nonLoreSkills : Dict String Skill -> Dict String Skill
nonLoreSkills dict =
    Dict.filter
        (\k _ ->
            not <| String.endsWith "Lore" k
        )
        dict


getSkill : Dict String Skill -> String -> Maybe Skill
getSkill dict name =
    Maybe.Extra.or
        ( Dict.get name dict )
        ( if String.endsWith "Lore" name then
            Just
                { name = name
                , keyAbility = Ability.Int
                }
          else
            Nothing
        )
