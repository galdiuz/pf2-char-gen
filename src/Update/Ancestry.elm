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
            -- state.
            -- asAncestryIn

            -- asNameIn state.currentCharacter.info name
            --     |> asInfoIn state.currentCharacter
            --     |> asCharacterIn state
            --     |> noCmd



asAncestryIn character ancestry =
    { character
        | ancestry =
            { ancestry = Just ancestry
            , options = Nothing
            }
    }


asCharacterIn state character =
    { state | currentCharacter = character }


noCmd state =
    ( state, Cmd.none )
