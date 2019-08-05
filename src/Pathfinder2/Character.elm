module Pathfinder2.Character exposing (..)

import Pathfinder2.Data.Ancestry exposing (Ancestry)
import Pathfinder2.Data.Class exposing (Class)


type alias Character =
    { info : CharacterInfo
    , ancestry : CharacterAncestry
    -- background : Background
    , class : Class
    --, abilities : Abilities
    }


type alias CharacterInfo =
    { name : String
    , player : String
    , campaign : String
    , alignment : String
    , level : Int
    , experience : Int
    , abilities : Abilities
    }


type alias CharacterAncestry =
    { ancestry : Maybe Ancestry
    , options : Maybe AncestryOptions
    }


type alias AncestryOptions =
    { abilityBoosts : List String
    , abilityFlaws : List String
    , heritage : Maybe String
    , languages : List String
    }


emptyAncestryOptions : AncestryOptions
emptyAncestryOptions =
    { abilityBoosts = []
    , abilityFlaws = []
    , heritage = Nothing
    , languages = []
    }


type Abilities
    = Standard
    | Rolled Int Int Int Int Int Int


--emptyCharacter : Character
emptyCharacter =
    { info =
        { name = ""
        , player = ""
        , campaign = ""
        , alignment = ""
        , level = 1
        , experience = 0
        , abilities = Standard
        }
    , ancestry =
        { name = ""
        }
    , class =
        { name = ""
        }
    }


--testCharacter : Character
testCharacter =
    { info =
        { name = "Monk Dude"
        , player = "Galdiuz"
        , campaign = ""
        , alignment = "NG"
        , level = 3
        , experience = 0
        , abilities = Standard
        }
    , class =
        { name = "Monk"
        }
    , ancestry =
        { ancestry = Nothing
        , options = Nothing
        }
    }


