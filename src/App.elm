module App exposing (init, render, subscriptions)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (Html)
import Url

import Yaml.Decode

import App.Flags exposing (Flags)
import App.Msg exposing (Msg)
import App.State as State exposing (State)
import App.UI as UI
import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Yaml as Yaml


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( State, Cmd Msg )
init flags url navKey =
    State.emptyState
        |> State.setData
            ( flags.data
                |> List.map (Yaml.Decode.fromString Yaml.decoder)
                |> List.map (Debug.log "data")
                |> List.map (Result.withDefault Data.emptyData)
                |> List.foldl (Data.mergeData) Data.emptyData
            )
        |> noCmd


render : State -> Document Msg
render state =
    { body = [ renderView state ]
    , title = "Title"
    }


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none


renderView : State -> Html Msg
renderView state =
    UI.render state



noCmd state =
    ( state, Cmd.none )
