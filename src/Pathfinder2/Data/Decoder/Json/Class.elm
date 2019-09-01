module Pathfinder2.Data.Decoder.Json.Class exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Json.Skill as Skill


decoder : Decoder (Data.Class Ability Ability.AbilityMod)
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "hitPoints" Decode.int <| \hitPoints ->
    Field.require "keyAbility" (Decode.list Decode.string) <| \boosts ->
    Field.require "skills" (Decode.list Skill.decoder) <| \skills ->
    Field.require "skillIncreases" Decode.int <| \skillIncreases ->
    Field.attempt "subclass" decodeSubclass <| \subclass ->
    Field.require "skillFeatLevels" (Decode.list Decode.int) <| \skillFeatLevels ->
    Field.require "skillIncreaseLevels" (Decode.list Decode.int) <| \skillIncreaseLevels ->

    let
        abilityBoosts =
            List.map Ability.fromString boosts
    in

    if not <| List.all Maybe.Extra.isJust abilityBoosts then
        Decode.fail "Invalid ability boost"
    else

    Decode.succeed
        { name = name
        , hitPoints = hitPoints
        , keyAbility =
            case abilityBoosts of
                [ Just ability ] ->
                    Ability.Fixed ability
                abilities ->
                    Ability.Choice <| List.filterMap identity abilities
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
