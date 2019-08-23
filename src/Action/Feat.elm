module Action.Feat exposing (Action(..))

import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


type Action
    = NoOp
    | SetFeat String Data.Feat
