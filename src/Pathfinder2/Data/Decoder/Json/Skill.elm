module Pathfinder2.Data.Decoder.Json.Skill exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability
import Pathfinder2.Data as Data


decoder : Decoder Data.Skill
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "keyAbility" Decode.string <| \rawKeyAbility ->

    case Ability.fromString rawKeyAbility of
        Nothing ->
            Decode.fail "Invalid key ability"
        Just keyAbility ->
            Decode.succeed
                { name = name
                , keyAbility = keyAbility
                }
