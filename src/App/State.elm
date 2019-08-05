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
    , currentCharacter = Character.testCharacter
    , data = Data.emptyData
    , currentView = View.Characters
    }


setData : Data -> State -> State
setData data state =
    { state | data = data }
