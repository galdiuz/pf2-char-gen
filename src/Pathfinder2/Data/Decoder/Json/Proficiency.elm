module Pathfinder2.Data.Decoder.Json.Proficiency exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)

decoder : Decoder Proficiency
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case Proficiency.fromString string of
                    Just proficiency ->
                        Decode.succeed proficiency
                    Nothing ->
                        Decode.fail <| "Unknown proficiency '" ++ string ++ "'"
            )
