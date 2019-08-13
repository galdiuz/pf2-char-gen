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
import Pathfinder2.Data.Decoder.Json as Json


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( State, Cmd Msg )
init flags url navKey =
    State.emptyState
        |> State.setData
            ( flags.data
                |> List.map (Json.decode)
                |> List.foldl (Data.mergeData) Data.emptyData
            )
        |> noCmd


render : State -> Document Msg
render state =
    { body = [ renderView state ]
    , title = "PF2 Char Gen"
    }


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none


renderView : State -> Html Msg
renderView state =
    UI.render state



noCmd state =
    ( state, Cmd.none )
