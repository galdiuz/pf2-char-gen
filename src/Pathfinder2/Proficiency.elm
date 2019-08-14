module Pathfinder2.Proficiency exposing
    ( Proficiency(..)
    , toString
    , modifier
    , compare
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


modifier : Proficiency -> Int -> Int
modifier proficiency level =
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


compare : Proficiency -> Proficiency -> Order
compare a b =
    if a == b then
        EQ
    else if a == Untrained then
        LT
    else if a == Trained && List.member b [Expert, Master, Legendary] then
        LT
    else if a == Expert && List.member b [Master, Legendary] then
        LT
    else if a == Master && b == Legendary then
        LT
    else
        GT
