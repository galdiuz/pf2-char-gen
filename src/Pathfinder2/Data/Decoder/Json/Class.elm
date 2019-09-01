module Pathfinder2.Data.Decoder.Json.Class exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Json.Ability as Ability
import Pathfinder2.Data.Decoder.Json.Skill as Skill


decoder : Decoder (Data.Class Ability.AbilityMod String)
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "hitPoints" Decode.int <| \hitPoints ->
    Field.require "keyAbility" (Decode.list Ability.decoder) <| \keyAbility ->
    Field.require "skills" (Decode.list Decode.string) <| \skills ->
    Field.require "skillIncreases" Decode.int <| \skillIncreases ->
    Field.attempt "subclass" decodeSubclass <| \subclass ->
    Field.require "skillFeatLevels" (Decode.list Decode.int) <| \skillFeatLevels ->
    Field.require "skillIncreaseLevels" (Decode.list Decode.int) <| \skillIncreaseLevels ->

    Decode.succeed
        { name = name
        , hitPoints = hitPoints
        , keyAbility =
            case keyAbility of
                [ fixed ] ->
                    Ability.Fixed fixed
                choice ->
                    Ability.Choice choice
        , skills = skills
        , skillIncreases = skillIncreases
        , subclass = subclass
        , skillFeatLevels = skillFeatLevels
        , skillIncreaseLevels = skillIncreaseLevels
        }


decodeSubclass : Decoder Data.Subclass
decodeSubclass =
    Field.require "name" Decode.string <| \name ->
    Field.require "options" (Decode.list Decode.string) <| \options ->

    Decode.succeed
        { name = name
        , options = options
        }
