module Pathfinder2.Data.Decoder.Yaml exposing (decoder)

import Dict

import Yaml.Decode as Decode
import Yaml.Decode.Field as Field

import Pathfinder2.Data exposing (Data)
import Pathfinder2.Data.Ancestry exposing (Ancestry)
import Pathfinder2.Data.Decoder.Yaml.Ancestry as Ancestry


decoder : Decode.Decoder Data
decoder =
    Decode.field "ancestries" (Decode.list Ancestry.decoder)
        |> Decode.andThen
            (\l ->
                Decode.succeed
                    { ancestries =
                        l
                            |> List.map (\v -> (v.name, v))
                            |> Dict.fromList

                    , classes = Dict.empty
                    }
            )
    -- Field.attempt "ancestries" (Decode.list Ancestry.decoder) <| \ancestries ->

    -- Decode.succeed
    --     { ancestries = Maybe.withDefault [] ancestries
    --     -- , classes = Maybe.withDefault [] classes
    --     , classes = []
    --     }
