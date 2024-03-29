module App.State exposing
    ( State
    , Inputs
    , emptyState
    , asCharacterIn
    , asDataIn
    , setWindow
    )

import App.View as View exposing (View)
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Prereq exposing (Prereq)


type alias Skill =
    Data.Skill Ability


type alias State =
    { character : Character
    , data : Data Ability Ability.AbilityMod Prereq Skill
    , currentView : View
    , modals : List View
    , window :
        { width : Int
        , height : Int
        }
    , inputs : Inputs
    }


type alias Inputs =
    { loreSkill : String
    }


emptyState : State
emptyState =
    { character = Character.emptyCharacter
    , data = Data.emptyData
    , currentView = View.Build
    , modals = []
    , window =
        { width = 0
        , height = 0
        }
    , inputs = emptyInputs
    }


emptyInputs : Inputs
emptyInputs =
    { loreSkill = ""
    }


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asDataIn : State -> Data Ability Ability.AbilityMod Prereq Skill -> State
asDataIn state data =
    { state | data = data }


setWindow : Int -> Int -> State -> State
setWindow width height state =
    { state
        | window =
            { width = width
            , height = height
            }
    }
