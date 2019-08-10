module App.Flags exposing (Flags)

import Json.Decode


type alias Flags =
    { data : List Json.Decode.Value
    }
