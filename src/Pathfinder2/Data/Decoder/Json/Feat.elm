module Pathfinder2.Data.Decoder.Json.Feat exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Maybe.Extra
import Json.Decode.Field as Field

import Pathfinder2.Ability as Ability
import Pathfinder2.Data as Data
import Pathfinder2.Prereq as Prereq exposing (Prereq)
import Pathfinder2.Proficiency as Proficiency


decoder : Decoder Data.Feat
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Field.optional "prereqs" singleOrListPrereq <| \prereqs ->

    Decode.succeed
        { name = name
        , level = level
        , traits = traits
        , prereqs = prereqs
        }


singleOrListPrereq =
    Decode.oneOf
        [ prereqDecoder
        , Decode.list prereqDecoder
            |> Decode.map Prereq.and
        ]


prereqDecoder : Decoder Prereq
prereqDecoder =
    Decode.oneOf
        [ Decode.field "and" (Decode.list <| Decode.lazy <| \_ -> prereqDecoder)
            |> Decode.map Prereq.and
        , Decode.field "or" (Decode.list <| Decode.lazy <| \_ -> prereqDecoder)
            |> Decode.map Prereq.or
        , Decode.field "skill" skillPrereq
        , Decode.field "feat" featPrereq
        , Decode.field "ability" abilityPrereq
        ]


skillPrereq : Decoder Prereq
skillPrereq =
    Field.require "name" Decode.string <| \name ->
    Field.require "rank" Proficiency.decoder <| \rank ->

    Decode.succeed
        <| Prereq.skill
            { name = name
            , rank = rank
            }


featPrereq : Decoder Prereq
featPrereq =
    Field.require "name" Decode.string <| \name ->

    Decode.succeed
        <| Prereq.feat
            { name = name
            }


abilityPrereq : Decoder Prereq
abilityPrereq =
    Field.require "name" Ability.decoder <| \ability ->
    Field.require "value" Decode.int <| \value ->

    Decode.succeed
        <| Prereq.ability
            { ability = ability
            , value = value
            }
