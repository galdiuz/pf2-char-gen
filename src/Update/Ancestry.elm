module Update.Ancestry exposing (update)

import Dict

import Action.Ancestry exposing (Action(..))
import Pathfinder2.Character as Character


update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetAncestry key ->
            case Dict.get key state.data.ancestries of
                Just ancestry ->
                    ancestry
                        |> asAncestryIn state.currentCharacter
                        |> asCharacterIn state
                        |> noCmd

                Nothing ->
                    state
                        |> noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state index value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd

        SetAbilityFlaw index value ->
            setAbilityFlaw state index value
                |> asOptionsIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd


setAbilityBoost state index value =
    let
        options = getOptions state
    in
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }


setAbilityFlaw state index value =
    let
        options = getOptions state
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


getOptions state =
    Maybe.withDefault Character.emptyAncestryOptions state.currentCharacter.ancestryOptions
