module App.View exposing (View(..))


type View
    = Build
    | Information
    | Ancestry
    | Background
    | Class
    | Abilities
    | AbilityBoosts Int
    | Heritage
    | Skill Int Int
    -- | Feats
    -- | Equipment
    -- | Spells
