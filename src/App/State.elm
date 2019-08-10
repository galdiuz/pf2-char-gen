module App.State exposing (State, emptyState, setData)

import App.View as View exposing (View)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data exposing (Data)


type alias State =
    { characters : List Character
    , currentCharacter : Character
    , data : Data
    , currentView : View
    }


emptyState =
    { characters = []
    , currentCharacter = Character.emptyCharacter
    , data = Data.emptyData
    , currentView = View.Background
    }


setData : Data -> State -> State
setData data state =
    { state | data = data }
