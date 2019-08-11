module Update.Abilities exposing (update)

import Action.Abilities exposing (Action(..))
import App.State exposing (State)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data.Ability exposing (Ability)


update : Action -> State -> (State, Cmd msg)
update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetAbilityBoosts abilities ->
            abilities
                |> asBoostsIn state.character
                |> asCharacterIn state
                |> noCmd


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asBoostsIn : Character -> List Ability -> Character
asBoostsIn character boosts =
    { character | freeBoosts = boosts }


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
