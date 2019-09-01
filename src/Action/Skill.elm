module Action.Skill exposing (Action(..))

import Pathfinder2.Data as Data
import Pathfinder2.Ability exposing (Ability)


type Action
    = NoOp
    | SetSkillIncrease Int (List (Data.Skill Ability))
    | SetLoreSkillInput String
    | AddLoreSkill String
