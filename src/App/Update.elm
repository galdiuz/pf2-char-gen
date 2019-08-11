module App.Update exposing (update)

import App.Msg exposing (Msg(..))
import App.State exposing (State)
import Update.Abilities as Abilities
import Update.Ancestry as Ancestry
import Update.Background as Background
import Update.Class as Class
import Update.Information as Information


update : Msg -> State -> ( State, Cmd msg )
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

        OpenModal view ->
            { state | modals = view :: state.modals }
                |> noCmd

        CloseModal ->
            { state | modals = List.drop 1 state.modals }
                |> noCmd

        Abilities action ->
            Abilities.update action state

        Ancestry action ->
            Ancestry.update action state

        Background action ->
            Background.update action state

        Class action ->
            Class.update action state

        Information action ->
            Information.update action state


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
