module Update.Class exposing (update)

import Dict

import Action.Class exposing (Action(..))
import App.State as State exposing (State)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


update : Action -> State -> ( State, Cmd msg )
update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetClass class ->
            class
                |> Character.asClassIn state.character
                |> State.asCharacterIn state
                |> noCmd

        SetKeyAbility ability ->
            ability
                |> asKeyAbilityIn state.character.classOptions
                |> Character.asClassOptionsIn state.character
                |> State.asCharacterIn state
                |> noCmd


asKeyAbilityIn : Character.ClassOptions -> Ability -> Character.ClassOptions
asKeyAbilityIn options ability =
    { options
        | keyAbility = Just ability
    }


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
