module Pathfinder2.Data.Decoder.Json.Background exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability
import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Json.Ability as Ability
import Pathfinder2.Data.Decoder.Json.Skill as Skill


decoder : Decoder Data.Background
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "abilityBoosts" (Decode.list Ability.decoder) <| \abilityBoosts ->
    Field.require "skills" (Decode.list Skill.decoder) <| \skills ->

    Decode.succeed
        { name = name
        , abilityBoosts = List.singleton <| Ability.Choice abilityBoosts
        , skills = skills
        }
