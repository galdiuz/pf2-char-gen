module Pathfinder2.Data.Decoder.Json.Feat exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Maybe.Extra
import Json.Decode.Field as Field

import Pathfinder2.Data as Data


decoder : Decoder Data.Feat
decoder =
    Field.require "name" Decode.string <| \name ->
    Field.require "level" Decode.int <| \level ->
    Field.require "traits" (Decode.list Decode.string) <| \traits ->
    -- Field.attempt "prereqs" (Decode.list Decode.string) <| \prereqs ->
    Field.attempt "prereqs" andOrComposite <| \prereqs ->

    let
        _ =
            Debug.log "prereqs" prereqs
    in
    Decode.succeed
        { name = name
        , level = level
        , traits = traits
        -- , prereqs = Maybe.withDefault [] prereqs
        , prereqs = []
        }


andOrComposite : Decoder Condition
andOrComposite =
    Decode.oneOf
        [ andList
        , composite
        ]


orOrComposite : Decoder Condition
orOrComposite =
    Decode.oneOf
        [ orList
        , composite
        ]


type Condition
    = Simple Prereq
    | Composite Composite


type Prereq
    = Skill { name : String, rank : String }
    | Feat { name : String }


type Composite
    = And (List Condition)
    | Or (List Condition)


andList : Decoder Condition
andList =
    Decode.map
        (Composite << And << List.map Simple)
        (Decode.list prereq)


orList : Decoder Condition
orList =
    Decode.map
        (Composite << Or << List.map Simple)
        (Decode.list prereq)


composite : Decoder Condition
composite =
    Field.require "type" Decode.string <| \type_ ->

    case type_ of
        "and" ->
            Decode.field "conditions" andOrComposite
        "or" ->
            Decode.field "conditions" orOrComposite
        _ ->
            Decode.fail "Unknown type"



prereq =
    Field.require "type" Decode.string <| \type_ ->

    case type_ of
        "skill" ->
            Field.require "name" Decode.string <| \name ->
            Field.require "rank" Decode.string <| \rank ->

            Decode.succeed
                <| Skill
                    { name = name
                    , rank = rank
                    }

        "feat" ->
            Field.require "name" Decode.string <| \name ->

            Decode.succeed
                <| Feat
                    { name = name
                    }

        _ ->
            Decode.fail "Unkown type"
