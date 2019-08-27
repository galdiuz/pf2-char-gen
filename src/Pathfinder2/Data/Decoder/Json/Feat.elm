module Pathfinder2.Data.Decoder.Json.Feat exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Maybe.Extra
import Json.Decode.Field as Field

import Fun
import Pathfinder2.Data as Data


decoder : Decoder Data.Feat
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    Fun.ifExists "prereqs" pre <| \prereq ->

    let
        _ =
            Debug.log "prereqs" prereq
    in
    Decode.succeed
        { name = name
        , level = level
        , traits = traits
        -- , prereqs = Maybe.withDefault [] prereqs
        , prereqs = []
        }


pre =
    Decode.oneOf
        [ prereqDecoder
        , Decode.list prereqDecoder
            |> Decode.map And
        ]


type Prereq
    = And (List Prereq)
    | Or (List Prereq)
    | Skill { name : String, rank : String }
    | Feat { name : String }
    | Ability { name : String, value : Int }


prereqDecoder : Decoder Prereq
prereqDecoder =
    Decode.oneOf
        [ Decode.field "and" (Decode.list <| Decode.lazy <| \_ -> prereqDecoder)
            |> Decode.map And
        , Decode.field "or" (Decode.list <| Decode.lazy <| \_ -> prereqDecoder)
            |> Decode.map Or
        , Decode.field "skill" skillPrereq
        , Decode.field "feat" featPrereq
        , Decode.field "ability" abilityPrereq
        ]


skillPrereq =
    Field.require "name" Decode.string <| \name ->
    Field.require "rank" Decode.string <| \rank ->

    Decode.succeed
        <| Skill
            { name = name
            , rank = rank
            }


featPrereq =
    Field.require "name" Decode.string <| \name ->

    Decode.succeed
        <| Feat
            { name = name
            }


abilityPrereq =
    Field.require "name" Decode.string <| \name ->
    Field.require "value" Decode.int <| \value ->

    Decode.succeed
        <| Ability
            { name = name
            , value = value
            }
