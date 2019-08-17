module App.State exposing (State, emptyState, setData, setWindow)

import App.View as View exposing (View)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data exposing (Data)


type alias State =
    { character : Character
    , data : Data
    , currentView : View
    , modals : List View
    , window :
        { width : Int
        , height : Int
        }
    }


emptyState : State
emptyState =
    { character = Character.emptyCharacter
    , data = Data.emptyData
    , currentView = View.Build
    -- , modals = []
    , modals = [ View.Skill 1 5 ]
    , window =
        { width = 0
        , height = 0
        }
    }


setData : Data -> State -> State
setData data state =
    { state | data = data }


setWindow : Int -> Int -> State -> State
setWindow width height state =
    { state
        | window =
            { width = width
            , height = height
            }
    }
