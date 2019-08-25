module Update.Class exposing (update)

import Dict

import Action.Class exposing (Action(..))
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

        SetClass class ->
            class
                |> Character.asClassIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetSubclass subclass ->
            subclass
                |> asSubclassIn state.character.classOptions
                |> Character.asClassOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetKeyAbility ability ->
            ability
                |> asKeyAbilityIn state.character.classOptions
                |> Character.asClassOptionsIn state.character
                |> State.asCharacterIn state
                |> Fun.noCmd


asKeyAbilityIn : Character.ClassOptions -> Ability -> Character.ClassOptions
asKeyAbilityIn options ability =
    { options
        | keyAbility = Just ability
    }


asSubclassIn : Character.ClassOptions -> String -> Character.ClassOptions
asSubclassIn options subclass =
    { options
        | subclass = Just subclass
    }
