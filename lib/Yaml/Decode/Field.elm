module Yaml.Decode.Field exposing (require, requireAt, attempt, attemptAt)

{-| Yaml decoder

Adapted from https://github.com/webbhuset/elm-json-decode

-}


import Yaml.Decode as Decode exposing (Decoder)


require : String -> Decoder a -> (a -> Decoder b) -> Decoder b
require fieldName valueDecoder continuation =
    Decode.field fieldName valueDecoder
        |> Decode.andThen continuation


requireAt : List String -> Decoder a -> (a -> Decoder b) -> Decoder b
requireAt path valueDecoder continuation =
    Decode.at path valueDecoder
        |> Decode.andThen continuation


attempt : String -> Decoder a -> (Maybe a -> Decoder b) -> Decoder b
attempt fieldName valueDecoder continuation =
    Decode.sometimes (Decode.field fieldName valueDecoder)
        |> Decode.andThen continuation


attemptAt : List String -> Decoder a -> (Maybe a -> Decoder b) -> Decoder b
attemptAt path valueDecoder continuation =
    Decode.sometimes (Decode.at path valueDecoder)
        |> Decode.andThen continuation
