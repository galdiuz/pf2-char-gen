module App.Update exposing (update)

import App.Msg exposing (Msg(..))
import App.State as State exposing (State)
import Fun
import Update.Abilities as Abilities
import Update.Ancestry as Ancestry
import Update.Background as Background
import Update.Class as Class
import Update.Information as Information
import Update.Skill as Skill


update : Msg -> State -> ( State, Cmd msg )
update msg state =
    case msg of
        NoOp ->
            state
                |> Fun.noCmd

        NewUrlRequest _ ->
            state
                |> Fun.noCmd

        NewLocation _ ->
            state
                |> Fun.noCmd

        OnResize width height ->
            state
                |> State.setWindow width height
                |> Fun.noCmd

        SetView view ->
            { state | currentView = view }
                |> Fun.noCmd

        OpenModal view ->
            { state | modals = view :: state.modals }
                |> Fun.noCmd

        CloseModal ->
            { state | modals = List.drop 1 state.modals }
                |> Fun.noCmd

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

        Skill action ->
            Skill.update action state
