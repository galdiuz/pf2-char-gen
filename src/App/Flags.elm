module App.Flags exposing (Flags)

import Yaml.Decode


type alias Flags =
    { data : List String
    }
