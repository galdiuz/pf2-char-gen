module Update.Information exposing (update)

import Action.Information exposing (Action(..))


update action state =
    case action of
        NoOp ->
            ( state, Cmd.none )

        SetName name ->
            name
                |> asNameIn state.character
                |> asCharacterIn state
                |> noCmd



asCharacterIn state character =
    { state | character = character }


asNameIn info name =
    { info | name = name }


noCmd state =
    ( state, Cmd.none )
