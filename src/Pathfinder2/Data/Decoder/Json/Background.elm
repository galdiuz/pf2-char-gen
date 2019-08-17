module Pathfinder2.Data.Decoder.Json.Background exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability
import Pathfinder2.Data as Data


decoder : Decoder Data.Background
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "abilityBoosts" (Decode.list Decode.string) <| \boosts ->
    Field.require "skills" (Decode.list Decode.string) <| \skills ->

    let
        abilityBoosts =
            List.map Ability.fromString boosts
    in

    if not <| List.all Maybe.Extra.isJust abilityBoosts then
        Decode.fail "Invalid ability boost"
    else

    Decode.succeed
        { name = name
        , abilityBoosts = List.singleton <| Ability.Choice <| List.filterMap identity abilityBoosts
        , skills = skills
        }
