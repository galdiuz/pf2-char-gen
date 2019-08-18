module Update.Abilities exposing (update)

import Dict

import Action.Abilities exposing (Action(..))
import App.State as State exposing (State)
import Fun
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)


update : Action -> State -> (State, Cmd msg)
update action state =
    case action of
        NoOp ->
            state
                |> Fun.noCmd

        SetBaseAbilities string ->
            case string of
                "Standard" ->
                    Ability.Standard
                        |> Character.asBaseAbilitiesIn state.character
                        |> State.asCharacterIn state
                        |> Fun.noCmd
                "Rolled" ->
                    Ability.Rolled Ability.defaultAbilities
                        |> Character.asBaseAbilitiesIn state.character
                        |> State.asCharacterIn state
                        |> Fun.noCmd
                _ ->
                    state
                        |> Fun.noCmd

        SetBaseAbility abilities ability string ->
            case (string, String.toInt string) of
                ("", _) ->
                    0
                        |> asAbilityIn abilities ability
                        |> asRolledAbilitiesIn state.character
                        |> State.asCharacterIn state
                        |> Fun.noCmd
                (_, Just value) ->
                    value
                        |> asAbilityIn abilities ability
                        |> asRolledAbilitiesIn state.character
                        |> State.asCharacterIn state
                        |> Fun.noCmd
                (_, Nothing) ->
                    state
                        |> Fun.noCmd


        SetAbilityBoosts level abilities ->
            abilities
                |> asBoostsIn state.character level
                |> State.asCharacterIn state
                |> Fun.noCmd


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
