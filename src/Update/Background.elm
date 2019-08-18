module Update.Background exposing (update)

import Dict

import Action.Background exposing (Action(..))
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

        SetBackground background ->
            background
                |> Character.asBackgroundIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.character.backgroundOptions index value
                |> Character.asBackgroundOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd


setAbilityBoost : Character.BackgroundOptions -> Int -> Ability -> Character.BackgroundOptions
setAbilityBoost options index value =
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }
