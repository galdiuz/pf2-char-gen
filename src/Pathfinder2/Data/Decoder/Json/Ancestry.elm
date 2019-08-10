module Pathfinder2.Data.Decoder.Json.Ancestry exposing (decoder)

import Maybe.Extra
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field

import Pathfinder2.Data.Ability as Ability
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)


decoder : Decoder Ancestry
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "hitpoints" Decode.int <| \hitpoints ->
    Field.require "size" Decode.string <| \size ->
    Field.require "speed" Decode.int <| \speed ->
    Field.require "abilityBoosts" (Decode.list Decode.string) <| \boosts ->
    Field.require "abilityFlaws" (Decode.list Decode.string) <| \flaws ->
    Field.require "languages" (Decode.list Decode.string) <| \languages ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Field.require "heritages" (Decode.list heritageDecoder) <| \heritages ->
    Field.require "feats" (Decode.list featDecoder) <| \feats ->

    let
        abilityBoosts =
            List.map Ability.modFromString boosts

        abilityFlaws =
            List.map Ability.modFromString flaws
    in

    if not <| List.all Maybe.Extra.isJust abilityBoosts then
        Decode.fail "Invalid ability boost"
    else

    if not <| List.all Maybe.Extra.isJust abilityFlaws then
        Decode.fail "Invalid ability flaw"
    else

    Decode.succeed
        { name = name
        , hitpoints = hitpoints
        , size = size
        , speed = speed
        , abilityBoosts = List.filterMap identity abilityBoosts
        , abilityFlaws = List.filterMap identity abilityFlaws
        , languages = languages
        , traits = traits
        , heritages = heritages
        , feats = feats
        }


heritageDecoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "description" Decode.string <| \description ->

    Decode.succeed
        { name = name
        , description = description
        }


featDecoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "description" Decode.string <| \description ->

    Decode.succeed
        { name = name
        , level = level
        , description = description
        }

