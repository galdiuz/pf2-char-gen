module Fun exposing (formatModifier, noCmd, sortWith, compare)

import List.Extra


formatModifier : Int -> String
formatModifier value =
    if value >= 1 then
        "+" ++ (String.fromInt value)
    else
        String.fromInt value


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )


sortWith : (a -> a -> Order) -> List (a -> a -> Order) -> List a -> List a
sortWith fun rem list =
    List.sortWith (sortWithRec fun rem) list


sortWithRec : (a -> a -> Order) -> List (a -> a -> Order) -> (a -> a -> Order)
sortWithRec fun rem =
    \a b ->
        case (fun a b, List.Extra.uncons rem) of
            (EQ, Just (x, y)) ->
                (sortWithRec x y) a b
            (order, _) ->
                order


compare : (a -> comparable) -> (a -> a -> Order)
compare fun =
    \a b ->
        Basics.compare (fun a) (fun b)
