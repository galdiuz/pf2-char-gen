module Pathfinder2.Data.Decoder.Json.Ability exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Pathfinder2.Ability as Ability exposing (Ability)


decoder : Decoder Ability
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case Ability.fromString string of
                    Just ability ->
                        Decode.succeed ability
                    Nothing ->
                        Decode.fail <| "Unknown ability '" ++ string ++ "'"
            )
