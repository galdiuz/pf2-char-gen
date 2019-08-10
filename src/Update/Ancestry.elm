module Update.Ancestry exposing (update)

import Dict

import Action.Ancestry exposing (Action(..))
import Pathfinder2.Character as Character


update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetAncestry ancestry ->
            ancestry
                |> asAncestryIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        SetVoluntaryFlaw value ->
            setVoluntaryFlaw state.currentCharacter value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.currentCharacter index value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        SetAbilityFlaw index value ->
            setAbilityFlaw state.currentCharacter index value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd


setVoluntaryFlaw character value =
    let
        options = Character.ancestryOptions character
    in
    { options
        | voluntaryFlaw = value
    }


setAbilityBoost character index value =
    let
        options = Character.ancestryOptions character
    in
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }


setAbilityFlaw character index value =
    let
        options = Character.ancestryOptions character
    in
    { options
        | abilityFlaws = Dict.insert index value <| .abilityFlaws options
    }


asAncestryIn character ancestry =
    { character
        | ancestry = Just ancestry
        , ancestryOptions = Nothing
    }


asOptionsIn character options =
    { character
        | ancestryOptions = Just options
    }


asCharacterIn state character =
    { state | currentCharacter = character }


noCmd state =
    ( state, Cmd.none )
