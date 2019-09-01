module App exposing (init, render, subscriptions)

import Browser exposing (Document)
import Browser.Events
import Browser.Navigation
import Html exposing (Html)
import Url

import App.Flags exposing (Flags)
import App.Msg as Msg exposing (Msg)
import App.State as State exposing (State)
import App.UI as UI
import Fun
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Data.Decoder.Json as Json


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( State, Cmd Msg )
init flags url navKey =
    decodeJsonData flags.data
        |> State.asDataIn State.emptyState
        |> State.setWindow flags.window.width flags.window.height
        |> Fun.noCmd


render : State -> Document Msg
render state =
    { body = [ renderView state ]
    , title = "PF2 Char Gen"
    }


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.batch
        [ Browser.Events.onResize Msg.OnResize
        ]


renderView : State -> Html Msg
renderView state =
    UI.render state


decodeJsonData jsonData =
    jsonData
        |> List.map Json.decode
        |> List.foldl Data.mergeData Data.emptyData
        |> Data.validateAndMergeData Data.emptyData
        |> (\result ->
            case result of
                Ok data ->
                    data
                Err msg ->
                    Debug.log "err" msg |> always
                    Data.emptyData
        )
