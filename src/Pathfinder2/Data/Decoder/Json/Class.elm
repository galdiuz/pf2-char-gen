module Pathfinder2.Data.Decoder.Json.Class exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Data.Ability as Ability
import Pathfinder2.Data.Class as Class exposing (Class)


decoder : Decoder Class
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "hitPoints" Decode.int <| \hitPoints ->
    Field.require "keyAbility" (Decode.list Decode.string) <| \boosts ->
    Field.require "skillFeats" (Decode.list Decode.int) <| \skillFeats ->
    Field.require "skillIncreases" (Decode.list Decode.int) <| \skillIncreases ->

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
        , skillFeats = skillFeats
        , skillIncreases = skillIncreases
        }
