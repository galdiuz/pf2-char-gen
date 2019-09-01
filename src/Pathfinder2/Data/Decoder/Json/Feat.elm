module Pathfinder2.Data.Decoder.Json.Feat exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Maybe.Extra
import Json.Decode.Field as Field

import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Json.Prereq as Prereq
import Pathfinder2.Prereq as Prereq exposing (Prereq)


decoder : Decoder (Data.Feat Prereq)
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Field.optional "prereqs" Prereq.decoder <| \prereqs ->

    Decode.succeed
        { name = name
        , level = level
        , traits = traits
        , prereqs = Maybe.withDefault Prereq.none prereqs
        }
