module Update.Abilities exposing (update)

import Dict

import Action.Abilities exposing (Action(..))
import App.State exposing (State)
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)


update : Action -> State -> (State, Cmd msg)
update action state =
    case action of
        NoOp ->
            state
                |> noCmd

        SetBaseAbilities string ->
            case string of
                "Standard" ->
                    Ability.Standard
                        |> asBaseAbilitiesIn state.character
                        |> asCharacterIn state
                        |> noCmd
                "Rolled" ->
                    Ability.Rolled Ability.defaultAbilities
                        |> asBaseAbilitiesIn state.character
                        |> asCharacterIn state
                        |> noCmd
                _ ->
                    state
                        |> noCmd

        SetBaseAbility abilities ability string ->
            case (string, String.toInt string) of
                ("", _) ->
                    0
                        |> asAbilityIn abilities ability
                        |> asRolledAbilitiesIn state.character
                        |> asCharacterIn state
                        |> noCmd
                (_, Just value) ->
                    value
                        |> asAbilityIn abilities ability
                        |> asRolledAbilitiesIn state.character
                        |> asCharacterIn state
                        |> noCmd
                (_, Nothing) ->
                    state
                        |> noCmd


        SetAbilityBoosts level abilities ->
            abilities
                |> asBoostsIn state.character level
                |> asCharacterIn state
                |> noCmd


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asBaseAbilitiesIn : Character -> Ability.BaseAbilities -> Character
asBaseAbilitiesIn character abilities =
    { character
        | baseAbilities = abilities
        , ancestryOptions = Character.emptyAncestryOptions
        , backgroundOptions = Character.emptyBackgroundOptions
        , abilityBoosts = Dict.empty
    }


asRolledAbilitiesIn : Character -> Ability.Abilities -> Character
asRolledAbilitiesIn character abilities =
    { character | baseAbilities = Ability.Rolled abilities }


asAbilityIn : Ability.Abilities -> Ability -> Int -> Ability.Abilities
asAbilityIn abilities ability value =
    case ability of
        Ability.Str ->
            { abilities | str = max 0 (min 20 value) }
        Ability.Dex ->
            { abilities | dex = max 0 (min 20 value) }
        Ability.Con ->
            { abilities | con = max 0 (min 20 value) }
        Ability.Int ->
            { abilities | int = max 0 (min 20 value) }
        Ability.Wis ->
            { abilities | wis = max 0 (min 20 value) }
        Ability.Cha ->
            { abilities | cha = max 0 (min 20 value) }


asBoostsIn : Character -> Int -> List Ability -> Character
asBoostsIn character level boosts =
    { character | abilityBoosts = Dict.insert level boosts character.abilityBoosts }


noCmd : state -> ( state, Cmd msg )
noCmd state =
    ( state, Cmd.none )
