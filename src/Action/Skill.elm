module Action.Skill exposing (Action(..))

import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetSkillIncrease Int Data.Skill
