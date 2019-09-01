module Pathfinder2.Data exposing (..)

import Dict exposing (Dict)

import Maybe.Extra

import Pathfinder2.Ability as Ability exposing (Ability)


type alias Data ability abilityMod prereq skill =
    { ancestries : Dict String (Ancestry abilityMod)
    , backgrounds : Dict String (Background abilityMod skill)
    , classes : Dict String (Class abilityMod skill)
    , skills : Dict String (Skill ability)
    , feats : Dict String (Feat prereq)
    }


type alias Ancestry abilityMod =
    { name : String
    , hitPoints : Int
    , size : String
    , speed : Int
    , abilityBoosts : List abilityMod
    , abilityFlaws : List abilityMod
    , languages : List String
    , traits : List String
    , heritages : List Heritage
    }


type alias Heritage =
    { name : String
    }


type alias Background abilityMod skill =
    { name : String
    , abilityBoosts : List abilityMod
    , skills : List skill
    }


type alias Class abilityMod skill =
    { name : String
    , hitPoints : Int
    , keyAbility : abilityMod
    , skills : List skill
    , skillIncreases : Int
    , subclass : Maybe Subclass
    , skillFeatLevels : List Int
    , skillIncreaseLevels : List Int
    }


type alias Subclass =
    { name : String
    , options : List String
    }


type alias Skill ability =
    { name : String
    , keyAbility : ability
    }


type alias Feat prereq =
    { name : String
    , level : Int
    , prereqs : prereq
    , traits : List String
    }


emptyData : Data ability abilityMod prereq skill
emptyData =
    { ancestries = Dict.empty
    , backgrounds = Dict.empty
    , classes = Dict.empty
    , skills = Dict.empty
    , feats = Dict.empty
    }


mergeData : Data a am p s -> Data a am p s -> Data a am p s
mergeData a b =
    { ancestries = Dict.union b.ancestries a.ancestries
    , backgrounds = Dict.union b.backgrounds a.backgrounds
    , classes = Dict.union b.classes a.classes
    , skills = Dict.union b.skills a.skills
    , feats = Dict.union b.feats a.feats
    }


skills : Data a am p (Skill a) -> Dict String (Skill a)
skills data =
    data.skills
    -- Dict.union
    --     ( data.backgrounds
    --         |> Dict.values
    --         |> List.map .skills
    --         |> List.concat
    --         |> List.map (\s -> (s.name, s))
    --         |> Dict.fromList
    --     )


compareSkills : Skill a -> Skill a -> Order
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


isLore : Skill a -> Bool
isLore skill =
    String.endsWith "Lore" skill.name


loreSkills : Dict String (Skill a) -> Dict String (Skill a)
loreSkills dict =
    Dict.filter
        (\k _ ->
            String.endsWith "Lore" k
        )
        dict


nonLoreSkills : Dict String (Skill a) -> Dict String (Skill a)
nonLoreSkills dict =
    Dict.filter
        (\k _ ->
            not <| String.endsWith "Lore" k
        )
        dict


getSkill : Dict String (Skill Ability) -> String -> Maybe (Skill Ability)
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


filterFeatsByTrait : String -> Dict String (Feat p) -> Dict String (Feat p)
filterFeatsByTrait trait feats =
    Dict.filter
        (\_ feat ->
            List.member trait feat.traits
        )
        feats


filterFeatsByLevel : Int -> Dict String (Feat p) -> Dict String (Feat p)
filterFeatsByLevel level feats =
    Dict.filter
        (\_ feat ->
            feat.level <= level
        )
        feats


validateAndMergeData :
    Data Ability am p (Skill Ability)
    -> Data Ability am p String
    -> Result String (Data Ability am p (Skill Ability))
validateAndMergeData oldData newData =
    let
        allSkills =
            Dict.union oldData.skills newData.skills

        getSkills field =
            newData
                |> field
                |> Dict.values
                |> List.map .skills
                |> List.concat
                |> List.map (\name -> (name, getSkill allSkills name))

        backgroundSkills =
            getSkills .backgrounds

        classSkills =
            getSkills .classes

        errors =
            List.filterMap
                (\(name, maybeSkill) ->
                    case maybeSkill of
                        Just skill ->
                            Nothing
                        Nothing ->
                            Just name
                )
                (backgroundSkills ++ classSkills)
    in
    if List.isEmpty errors then
        { ancestries = newData.ancestries
        , backgrounds =
            Dict.map
                (\_ v ->
                    { name = v.name
                    , abilityBoosts = v.abilityBoosts
                    , skills = List.filterMap (\name -> getSkill allSkills name) v.skills
                    }
                )
                newData.backgrounds
        , classes =
            Dict.map
                (\_ v ->
                    { name = v.name
                    , hitPoints = v.hitPoints
                    , keyAbility = v.keyAbility
                    , skills = List.filterMap (\name -> getSkill allSkills name) v.skills
                    , skillIncreases = v.skillIncreases
                    , subclass = v.subclass
                    , skillFeatLevels = v.skillFeatLevels
                    , skillIncreaseLevels = v.skillIncreaseLevels
                    }
                )
            newData.classes
        , skills = newData.skills
        , feats = newData.feats
        }
            |> mergeData oldData
            |> Ok
    else
        Err <| "Undefined skill(s): " ++ (String.join ", " errors)
