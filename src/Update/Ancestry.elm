module Update.Ancestry exposing (update)

import Dict

import Action.Ancestry exposing (Action(..))
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

        SetAncestry ancestry ->
            ancestry
                |> Character.asAncestryIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetVoluntaryFlaw value ->
            setVoluntaryFlaw state.character.ancestryOptions value
                |> Character.asAncestryOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.character.ancestryOptions index value
                |> Character.asAncestryOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetAbilityFlaw index value ->
            setAbilityFlaw state.character.ancestryOptions index value
                |> Character.asAncestryOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd


setVoluntaryFlaw : Character.AncestryOptions -> Bool -> Character.AncestryOptions
setVoluntaryFlaw options value =
    { options
        | voluntaryFlaw = value
        , abilityBoosts = Dict.empty
        , abilityFlaws = Dict.empty
    }


setAbilityBoost : Character.AncestryOptions -> Int -> Ability -> Character.AncestryOptions
setAbilityBoost options index value =
    { options
        | abilityBoosts = Dict.insert index value <| .abilityBoosts options
    }


setAbilityFlaw : Character.AncestryOptions -> Int -> Ability -> Character.AncestryOptions
setAbilityFlaw options index value =
    { options
        | abilityFlaws = Dict.insert index value <| .abilityFlaws options
    }
