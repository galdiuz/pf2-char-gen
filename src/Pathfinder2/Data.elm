module Pathfinder2.Data exposing (Data, emptyData, mergeData)

import Dict exposing (Dict)

import Pathfinder2.Data.Ancestry exposing (Ancestry)
import Pathfinder2.Data.Background exposing (Background)
import Pathfinder2.Data.Class exposing (Class)


type alias Data =
    { ancestries : Dict String Ancestry
    , backgrounds : Dict String Background
    , classes : Dict String Class
    }


emptyData : Data
emptyData =
    { ancestries = Dict.empty
    , backgrounds = Dict.empty
    , classes = Dict.empty
    }


mergeData : Data -> Data -> Data
mergeData a b =
    { ancestries = Dict.union b.ancestries a.ancestries
    , backgrounds = Dict.union b.backgrounds a.backgrounds
    , classes = Dict.union b.classes a.classes
    }
