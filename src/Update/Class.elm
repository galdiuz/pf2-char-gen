module Update.Class exposing (update)

import Dict

import Action.Class exposing (Action(..))
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

        SetClass class ->
            class
                |> asClassIn state.character
                |> asCharacterIn state
                |> noCmd

        SetKeyAbility ability ->
            ability
                |> asKeyAbilityIn state.character.classOptions
                |> asOptionsIn state.character
                |> asCharacterIn state
                |> noCmd


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asClassIn : Character -> Data.Class -> Character
asClassIn character class =
    { character
        | class = Just class
        , classOptions = Character.emptyClassOptions
    }


asOptionsIn : Character -> Character.ClassOptions -> Character
asOptionsIn character options =
    { character
        | classOptions = options
    }


asKeyAbilityIn : Character.ClassOptions -> Ability -> Character.ClassOptions
asKeyAbilityIn options ability =
    { options
        | keyAbility = Just ability
    }


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
