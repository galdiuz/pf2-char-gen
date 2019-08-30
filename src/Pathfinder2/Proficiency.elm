module Pathfinder2.Proficiency exposing
    ( Proficiency(..)
    , toString
    , fromString
    , decoder
    , modifier
    , compare
    , rank
    , maxProficiency
    )

import Json.Decode as Decode exposing (Decoder)


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


fromString : String -> Maybe Proficiency
fromString string =
    case string of
        "Untrained" ->
            Just Untrained
        "Trained" ->
            Just Trained
        "Expert" ->
            Just Expert
        "Master" ->
            Just Master
        "Legendary" ->
            Just Legendary
        _ ->
            Nothing


decoder : Decoder Proficiency
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case fromString string of
                    Just proficiency ->
                        Decode.succeed proficiency
                    Nothing ->
                        Decode.fail <| "Unknown proficiency '" ++ string ++ "'"
            )


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


rank : Int -> Proficiency
rank ranks =
    case ranks of
        0 -> Untrained
        1 -> Trained
        2 -> Expert
        3 -> Master
        _ -> Legendary


maxProficiency : Int -> Proficiency
maxProficiency level =
    if level < 7 then
        Expert
    else if level < 15 then
        Master
    else
        Legendary
