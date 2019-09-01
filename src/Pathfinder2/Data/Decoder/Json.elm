module Pathfinder2.Data.Decoder.Json exposing (decode)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Data.Decoder.Json.Ancestry as Ancestry
import Pathfinder2.Data.Decoder.Json.Background as Background
import Pathfinder2.Data.Decoder.Json.Class as Class
import Pathfinder2.Data.Decoder.Json.Feat as Feat
import Pathfinder2.Data.Decoder.Json.Skill as Skill
import Pathfinder2.Prereq exposing (Prereq)


type alias NamedRecord r =
    { r | name : String }


decode : Decode.Value -> Data Ability Ability.AbilityMod Prereq String
decode value =
    Decode.decodeValue decoder value
        |> (\result ->
            case result of
                Ok _ ->
                    result
                Err error ->
                    Debug.log "decode error" (Decode.errorToString error)
                        |> always result
        )
        |> Result.withDefault Data.emptyData


decoder : Decoder (Data Ability Ability.AbilityMod Prereq String)
decoder =
    Field.optional "ancestries" (Decode.list Ancestry.decoder) <| \ancestries ->
    Field.optional "backgrounds" (Decode.list Background.decoder) <| \backgrounds ->
    Field.optional "classes" (Decode.list Class.decoder) <| \classes ->
    Field.optional "feats" (Decode.list Feat.decoder) <| \feats ->
    Field.optional "skills" (Decode.list Skill.decoder) <| \skills ->

    Decode.succeed
        { ancestries = mapMaybe ancestries
        , backgrounds = mapMaybe backgrounds
        , classes = mapMaybe classes
        , feats = mapMaybe feats
        , skills = mapMaybe skills
        }


mapMaybe : Maybe (List (NamedRecord r)) -> Dict String (NamedRecord r)
mapMaybe maybeList =
    maybeList
        |> Maybe.withDefault []
        |> List.map (\v -> (v.name, v))
        |> Dict.fromList
