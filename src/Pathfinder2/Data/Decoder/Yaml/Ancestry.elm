module Pathfinder2.Data.Decoder.Yaml.Ancestry exposing (decoder)

import Yaml.Decode as Decode exposing (Decoder)
import Yaml.Decode.Field as Field
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)


decoder : Decoder Ancestry
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "hitpoints" Decode.int <| \hitpoints ->
    Field.require "size" Decode.string <| \size ->
    Field.require "speed" Decode.int <| \speed ->
    --boosts
    --flaws
    Field.require "languages" (Decode.list Decode.string) <| \languages ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Field.require "heritages" (Decode.list heritageDecoder) <| \heritages ->
    Field.require "feats" (Decode.list featDecoder) <| \feats ->

    Decode.succeed
        { name = name
        , hitpoints = hitpoints
        , size = size
        , speed = speed
        , abilityBoosts = []
        , abilityFlaws = []
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

