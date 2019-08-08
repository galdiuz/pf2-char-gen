module Pathfinder2.Data.Decoder.Yaml exposing (decode)

import Dict exposing (Dict)

import Yaml.Decode as Decode exposing (Decoder)
import Yaml.Decode.Field as Field

import Pathfinder2.Data exposing (Data)
import Pathfinder2.Data.Ancestry exposing (Ancestry)
import Pathfinder2.Data.Decoder.Yaml.Ancestry as Ancestry
import Pathfinder2.Data.Decoder.Yaml.Background as Background


type alias NamedRecord r =
    { r | name : String }


decode : String -> Data
decode yaml =
    { ancestries = tryDecode "ancestries" Ancestry.decoder yaml
    , backgrounds = tryDecode "backgrounds" Background.decoder yaml
    , classes = tryDecode "classes" (Decode.fail "todo") yaml
    }


tryDecode : String -> Decoder (NamedRecord r) -> String -> Dict String (NamedRecord r)
tryDecode field decoder yaml =
    Decode.fromString (Decode.field field (Decode.list decoder)) yaml
        |> Result.withDefault []
        |> List.map (\v -> (v.name, v))
        |> Dict.fromList
