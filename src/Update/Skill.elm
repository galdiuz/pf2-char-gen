module Update.Skill exposing (update)

import Dict

import Action.Skill exposing (Action(..))
import App.State exposing (State)
import Fun
import Pathfinder2.Character as Character exposing (Character)


update : Action -> State -> (State, Cmd msg)
update action state =
    case action of
        NoOp ->
            state
                |> Fun.noCmd

        SetSkillIncrease level skill ->
            skill
                |> asSkillIncreaseIn state.character level
                |> asCharacterIn state
                |> Fun.noCmd


asCharacterIn : State -> Character -> State
asCharacterIn state character =
    { state | character = character }


asSkillIncreaseIn character level skill =
    { character | skillIncreases = Dict.insert level skill character.skillIncreases }
