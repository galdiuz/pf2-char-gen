module Update.Skill exposing (update)

import Dict exposing (Dict)

import String.Extra

import Action.Skill exposing (Action(..))
import App.State as State exposing (State)
import Fun
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Character as Character exposing (Character)
import Pathfinder2.Data as Data exposing (Data)


type alias Skill =
    Data.Skill Ability


update : Action -> State -> (State, Cmd msg)
update action state =
    case action of
        NoOp ->
            state
                |> Fun.noCmd

        SetSkillIncrease level skills ->
            skills
                |> asSkillIncreaseIn state.character level
                |> State.asCharacterIn state
                |> Fun.noCmd

        SetLoreSkillInput string ->
            { loreSkill = string }
                |> asInputsIn state
                |> Fun.noCmd


        AddLoreSkill name ->
            if String.isEmpty name then
                state
                    |> Fun.noCmd
            else
                name
                    |> String.Extra.toTitleCase
                    |> String.trim
                    |> String.left 64
                    |> asLoreSkillIn state.data.skills
                    |> asSkillsIn state.data
                    |> State.asDataIn
                        ( { loreSkill = "" }
                            |> asInputsIn state
                        )
                    |> Fun.noCmd


asSkillIncreaseIn character level skill =
    { character | skillIncreases = Dict.insert level skill character.skillIncreases }


asSkillsIn : Data Ability am p Skill -> Dict String Skill -> Data Ability am p Skill
asSkillsIn data skills =
    { data | skills = skills }


asLoreSkillIn : Dict String Skill -> String -> Dict String Skill
asLoreSkillIn skills name =
    Dict.insert
        name
        { name = name ++ " Lore"
        , keyAbility = Ability.Int
        }
        skills


asInputsIn : State -> State.Inputs -> State
asInputsIn state inputs =
    { state | inputs = inputs }
