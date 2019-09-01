module Pathfinder2.Prereq exposing
    ( Prereq(..)
    , none
    , and
    , or
    , ability
    , feat
    , skill
    )

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)


type Prereq
    = None
    | And (List Prereq)
    | Or (List Prereq)
    | Ability AbilityData
    | Feat FeatData
    | Skill SkillData


type alias AbilityData =
    { ability : Ability
    , value : Int
    }


type alias FeatData =
    { name : String
    }


type alias SkillData =
    { name : String
    , rank : Proficiency
    }


none : Prereq
none =
    None


and : List Prereq -> Prereq
and list =
    case list of
        [] ->
            None

        [prereq] ->
            prereq

        _ ->
            And list


or : List Prereq -> Prereq
or list =
    case list of
        [] ->
            None

        [prereq] ->
            prereq

        _ ->
            Or list


ability : AbilityData -> Prereq
ability data =
    Ability data


feat : FeatData -> Prereq
feat data =
    Feat data


skill : SkillData -> Prereq
skill data =
    Skill data
