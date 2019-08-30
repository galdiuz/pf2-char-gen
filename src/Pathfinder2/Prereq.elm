module Pathfinder2.Prereq exposing
    ( Prereq(..)
    , and
    , or
    , ability
    , feat
    , skill
    )

import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Proficiency exposing (Proficiency)


type Prereq
    = And (List Prereq)
    | Or (List Prereq)
    | Ability AbilityPrereq
    | Feat FeatPrereq
    | Skill SkillPrereq


type alias AbilityPrereq =
    { ability : Ability
    , value : Int
    }


type alias FeatPrereq =
    { name : String
    }


type alias SkillPrereq =
    { name : String
    , rank : Proficiency
    }


and : List Prereq -> Prereq
and list =
    case list of
        [prereq] ->
            prereq
        _ ->
            And list


or : List Prereq -> Prereq
or list =
    case list of
        [prereq] ->
            prereq
        _ ->
            Or list


ability : AbilityPrereq -> Prereq
ability data =
    Ability data


feat : FeatPrereq -> Prereq
feat data =
    Feat data


skill : SkillPrereq -> Prereq
skill data =
    Skill data
