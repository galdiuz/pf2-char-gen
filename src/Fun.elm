module Fun exposing (formatModifier, noCmd)


formatModifier : Int -> String
formatModifier value =
    if value >= 1 then
        "+" ++ (String.fromInt value)
    else
        String.fromInt value


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
