module App.State exposing (State, emptyState, setData)

import App.View as View exposing (View)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data exposing (Data)


type alias State =
    { character : Character
    , data : Data
    , currentView : View
    , currentModal : Maybe View
    }


emptyState =
    { character = Character.emptyCharacter
    , data = Data.emptyData
    , currentView = View.Build
    , currentModal = Nothing
    }


setData : Data -> State -> State
setData data state =
    { state | data = data }
