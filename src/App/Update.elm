module App.Update exposing (update)

import App.Msg exposing (Msg(..), noCmd)
import Update.Ancestry as Ancestry
import Update.Background as Background
import Update.Information as Information


-- update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        NoOp ->
            state
                |> noCmd

        NewUrlRequest _ ->
            state
                |> noCmd

        NewLocation _ ->
            state
                |> noCmd

        SetView view ->
            { state | currentView = view }
                |> noCmd

        SetModal view ->
            { state | currentModal = Just view }
                |> noCmd

        CloseModal ->
            { state | currentModal = Nothing }
                |> noCmd

        Ancestry action ->
            Ancestry.update action state

        Background action ->
            Background.update action state

        Information action ->
            Information.update action state
