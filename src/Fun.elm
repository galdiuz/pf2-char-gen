module Fun exposing (formatModifier, noCmd, sortWith, compare, reverse)

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


sortWith : List (a -> a -> Order) -> List a -> List a
sortWith funs list =
    case List.Extra.uncons funs of
        Just (fun, rem) ->
            List.sortWith (sortWithRec fun rem) list
        Nothing ->
            list


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


reverse : (a -> a -> Order) -> (a -> a -> Order)
reverse fun =
    \a b ->
        case fun a b of
            LT -> GT
            EQ -> EQ
            GT -> LT
