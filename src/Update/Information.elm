module Update.Information exposing (update)

import Action.Information exposing (Action(..))


update action state =
    case action of
        NoOp ->
            ( state, Cmd.none )

        SetName name ->
            asNameIn state.currentCharacter.info name
                |> asInfoIn state.currentCharacter
                |> asCharacterIn state
                |> noCmd



asCharacterIn state character =
    { state | currentCharacter = character }


asInfoIn character info =
    { character | info = info }


asNameIn info name =
    { info | name = name }


noCmd state =
    ( state, Cmd.none )
