module Update.Background exposing (update)

import Dict

import Action.Background exposing (Action(..))
import Pathfinder2.Character as Character


update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetBackground background ->
            background
                |> asBackgroundIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.currentCharacter index value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        -- _ ->
        --     Debug.todo "TODO"


noCmd state =
    ( state, Cmd.none )

asCharacterIn state character =
    { state | currentCharacter = character }


asBackgroundIn character background =
    { character
        | background = Just background
        , backgroundOptions = Nothing
    }


asOptionsIn character options =
    { character
        | backgroundOptions = Just options
    }


setAbilityBoost character index value =
    let
        options = Character.backgroundOptions character
    in
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }
