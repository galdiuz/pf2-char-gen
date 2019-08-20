module Pathfinder2.Data.Decoder.Json exposing (decode)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field

import Pathfinder2.Data exposing (Data)
import Pathfinder2.Data.Decoder.Json.Ancestry as Ancestry
import Pathfinder2.Data.Decoder.Json.Background as Background
import Pathfinder2.Data.Decoder.Json.Class as Class
import Pathfinder2.Data.Decoder.Json.Feat as Feat
import Pathfinder2.Data.Decoder.Json.Skill as Skill


type alias NamedRecord r =
    { r | name : String }


decode : Decode.Value -> Data
decode value =
    { ancestries = tryDecode "ancestries" Ancestry.decoder value
    , backgrounds = tryDecode "backgrounds" Background.decoder value
    , classes = tryDecode "classes" Class.decoder value
    , skills = tryDecode "skills" Skill.decoder value
    , feats = tryDecode "feats" Feat.decoder value
    }


tryDecode : String -> Decoder (NamedRecord r) -> Decode.Value -> Dict String (NamedRecord r)
tryDecode field decoder value =
    Decode.decodeValue (Decode.field field (Decode.list decoder)) value
        |> Debug.log "decode"
        |> Result.withDefault []
        |> List.map (\v -> (v.name, v))
        |> Dict.fromList
