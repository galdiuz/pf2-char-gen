module Pathfinder2.Data.Decoder.Json.Skill exposing (decoder)

import Json.Decode as Decode exposing (Decoder)

import Json.Decode.Field as Field
import Maybe.Extra

import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data
import Pathfinder2.Data.Decoder.Json.Ability as Ability


decoder : Decoder (Data.Skill Ability)
decoder =
    Field.require "name" Decode.string <| \name ->

    if String.endsWith "Lore" name then
        Decode.succeed
            { name = name
            , keyAbility = Ability.Int
            }
    else
        Field.require "keyAbility" Ability.decoder <| \keyAbility ->

        Decode.succeed
            { name = name
            , keyAbility = keyAbility
            }
