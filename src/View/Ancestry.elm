module View.Ancestry exposing (render)

import Dict exposing (Dict)

import Maybe.Extra
import Element as El exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import Action.Ancestry as Ancestry
import App.Msg as Msg exposing (Msg)
import App.State as State exposing (State)
import Pathfinder2.Data as Data exposing (Data)
import Pathfinder2.Data.Ability as Ability exposing (Ability)
import Pathfinder2.Data.Ancestry as Ancestry exposing (Ancestry)
import Pathfinder2.Character as Character exposing (Character)
import UI.ChooseOne




render : State -> Element Msg
render state =
    El.column
        [ El.alignTop
        , El.width El.fill
        , El.spacing 5
        ]
        [ El.el
            [ Font.bold
            , Font.size 24
            ]
            <| El.text "Ancestry"
        , UI.ChooseOne.render
            { all = Dict.values state.data.ancestries
            , available = Dict.values state.data.ancestries
            , selected = state.character.ancestry
            , onChange = Msg.Ancestry << Ancestry.SetAncestry
            , toString = .name
            }
        ]




-- abilityBoosts : Ancestry -> Character -> Element Msg
-- abilityBoosts ancestry character =
--     El.column
--         [ El.spacing 10
--         ]
--         (
--         [ El.el
--             [ Font.heavy
--             ]
--             <| El.text "Ability Boosts"
--         , El.row
--             []
--             [ Input.checkbox
--                 []
--                 { onChange = Msg.Ancestry << Ancestry.SetVoluntaryFlaw
--                 , icon = Input.defaultCheckbox
--                 , checked =
--                     Maybe.map .voluntaryFlaw character.ancestryOptions
--                         |> Maybe.withDefault False
--                 , label =
--                     Input.labelRight
--                         []
--                         <| El.text "Voluntary Flaw"
--                 }
--             ]
--         , El.column
--             [ El.spacing 15 ]
--             <| List.indexedMap (renderAbilityMod ancestry character Boost)
--             <| Character.ancestryAbilityBoosts character
--         ]
--         ++
--         if List.isEmpty <| Character.ancestryAbilityFlaws character then
--             []
--         else
--             [ El.el
--                 [ Font.heavy
--                 ]
--                 <| El.text "Ability Flaws"
--             , El.column
--                 [ El.spacing 15 ]
--                 <| List.indexedMap (renderAbilityMod ancestry character Flaw)
--                 <| Character.ancestryAbilityFlaws character
--             ]
--         )


