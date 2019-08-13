module Pathfinder2.Proficiency exposing (Proficiency, bonus)


type Proficiency
    = Untrained
    | Trained
    | Expert
    | Master
    | Legendary


bonus : Proficiency -> Int -> Int
bonus proficiency ability =
    case proficiency of
        Untrained ->
            0
        Trained ->
            2 + ability
        Expert ->
            4 + ability
        Master ->
            6 + ability
        Legendary ->
            8 + ability
