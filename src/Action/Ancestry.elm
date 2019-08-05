module Action.Ancestry exposing (Action(..))

type Action
    = NoOp
    | SetAncestry String
