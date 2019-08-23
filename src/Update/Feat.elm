module Update.Feat exposing (update)

import Dict

import Action.Feat exposing (Action(..))
import App.State as State exposing (State)
import Fun
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


update : Action -> State -> ( State, Cmd msg )
update action state =
    case action of
        NoOp ->
            state
                |> Fun.noCmd

        SetFeat key feat ->
            Character.setFeat key feat state.character
                |> State.asCharacterIn state
                |> Fun.noCmd
