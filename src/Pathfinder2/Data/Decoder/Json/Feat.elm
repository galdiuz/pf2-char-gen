module Pathfinder2.Data.Decoder.Json.Feat exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Maybe.Extra
import Json.Decode.Field as Field

import Pathfinder2.Data as Data


decoder : Decoder Data.Feat
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Field.attempt "prereqs" (Decode.list Decode.string) <| \prereqs ->

    Decode.succeed
        { name = name
        , level = level
        , traits = traits
        , prereqs = Maybe.withDefault [] prereqs
        }

