module Update.Background exposing (update)

import Dict

import Action.Background exposing (Action(..))
import App.State exposing (State)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Ability exposing (Ability)
import Pathfinder2.Data as Data


update : Action -> State -> ( State, Cmd msg )
update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetBackground background ->
            background
                |> asBackgroundIn state.character
                |> asCharacterIn state
                |> noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.character.backgroundOptions index value
                |> asOptionsIn state.character
                |> asCharacterIn state
                |> noCmd


noCmd state =
    ( state, Cmd.none )


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asBackgroundIn : Character -> Data.Background -> Character
asBackgroundIn character background =
    { character
        | background = Just background
        , backgroundOptions = Character.emptyBackgroundOptions
    }


asOptionsIn : Character -> Character.BackgroundOptions -> Character
asOptionsIn character options =
    { character
        | backgroundOptions = options
    }


setAbilityBoost : Character.BackgroundOptions -> Int -> Ability -> Character.BackgroundOptions
setAbilityBoost options index value =
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }
