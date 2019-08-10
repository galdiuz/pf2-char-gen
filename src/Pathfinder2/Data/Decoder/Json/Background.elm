module Pathfinder2.Data.Decoder.Json.Background exposing (decoder)

import Maybe.Extra
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field

import Pathfinder2.Data.Ability as Ability
import Pathfinder2.Data.Background as Background exposing (Background)


decoder : Decoder Background
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "abilityBoosts" (Decode.list Decode.string) <| \boosts ->

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
        }
