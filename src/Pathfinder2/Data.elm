module Pathfinder2.Data exposing (Data, emptyData, mergeData)

import Dict exposing (Dict)

import Pathfinder2.Data.Ancestry exposing (Ancestry)
import Pathfinder2.Data.Class exposing (Class)


type alias Data =
    { ancestries : Dict String Ancestry
    , classes : Dict String Class
    }


emptyData : Data
emptyData =
    { ancestries = Dict.empty
    , classes = Dict.empty
    }


mergeData : Data -> Data -> Data
mergeData a b =
    a