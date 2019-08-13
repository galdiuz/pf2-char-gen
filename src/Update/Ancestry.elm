module Update.Ancestry exposing (update)

import Dict

import Action.Ancestry exposing (Action(..))
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

        SetAncestry ancestry ->
            ancestry
                |> asAncestryIn state.character
                |> asCharacterIn state
                |> noCmd

        SetVoluntaryFlaw value ->
            setVoluntaryFlaw state.character.ancestryOptions value
                |> asOptionsIn state.character
                |> asCharacterIn state
                |> noCmd

        SetAbilityBoost index value ->
            setAbilityBoost state.character.ancestryOptions index value
                |> asOptionsIn state.character
                |> asCharacterIn state
                |> noCmd

        SetAbilityFlaw index value ->
            setAbilityFlaw state.character.ancestryOptions index value
                |> asOptionsIn state.character
                |> asCharacterIn state
                |> noCmd


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asAncestryIn : Character -> Data.Ancestry -> Character
asAncestryIn character ancestry =
    { character
        | ancestry = Just ancestry
        , ancestryOptions = Character.emptyAncestryOptions
    }


asOptionsIn : Character -> Character.AncestryOptions -> Character
asOptionsIn character options =
    { character
        | ancestryOptions = options
    }


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


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
