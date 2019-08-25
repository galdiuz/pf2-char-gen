module App.View exposing (View(..))

import Pathfinder2.Data as Data


type View
    = Build
    | Information
    | Ancestry
    | Background
    | Class
    | Subclass Data.Subclass
    | Abilities
    | AbilityBoosts Int
    | Heritage
    | Skill Int Int
    | Feat Int String String
    -- | Equipment
    -- | Spells
