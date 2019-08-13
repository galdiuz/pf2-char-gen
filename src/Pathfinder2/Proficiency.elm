module Pathfinder2.Proficiency exposing
    ( Proficiency(..)
    , toString
    , bonus
    , bonusString
    )


type Proficiency
    = Untrained
    | Trained
    | Expert
    | Master
    | Legendary


toString : Proficiency -> String
toString proficiency =
    case proficiency of
        Untrained -> "Untrained"
        Trained -> "Trained"
        Expert -> "Expert"
        Master -> "Master"
        Legendary -> "Legendary"


bonus : Proficiency -> Int -> Int
bonus proficiency level =
    case proficiency of
        Untrained ->
            0
        Trained ->
            2 + level
        Expert ->
            4 + level
        Master ->
            6 + level
        Legendary ->
            8 + level


bonusString : Proficiency -> Int -> String
bonusString proficiency level =
    if bonus proficiency level >= 1 then
        "+" ++ (String.fromInt <| bonus proficiency level)
    else
        String.fromInt <| bonus proficiency level
