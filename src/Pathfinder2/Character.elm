module Pathfinder2.Character exposing (..)

import Dict exposing (Dict)
import List.Extra
import Pathfinder2.Ability as Ability exposing (Ability)
import Pathfinder2.Data as Data
import Pathfinder2.Proficiency as Proficiency exposing (Proficiency)


type alias Character =
    { name : String
    , player : String
    , campaign : String
    , alignment : String
    , level : Int
    , experience : Int
    , baseAbilities : Ability.BaseAbilities
    , ancestry : Maybe Data.Ancestry
    , ancestryOptions : AncestryOptions
    , background : Maybe Data.Background
    , backgroundOptions : BackgroundOptions
    , class : Maybe Data.Class
    , classOptions : ClassOptions
    , abilityBoosts : Dict Int (List Ability)
    , skillIncreases : Dict Int (List Data.Skill)
    }


type alias AncestryOptions =
    { abilityBoosts : Dict Int Ability
    , abilityFlaws : Dict Int Ability
    , voluntaryFlaw : Bool
    , heritage : Maybe String
    , languages : List String
    }


type alias BackgroundOptions =
    { abilityBoosts : Dict Int Ability
    }


type alias ClassOptions =
    { keyAbility : Maybe Ability
    }


emptyCharacter : Character
emptyCharacter =
    { name = ""
    , player = ""
    , campaign = ""
    , alignment = ""
    , level = 1
    , experience = 0
    , baseAbilities = Ability.Standard
    , ancestry = Nothing
    , ancestryOptions = emptyAncestryOptions
    , background = Nothing
    , backgroundOptions = emptyBackgroundOptions
    , class = Nothing
    , classOptions = emptyClassOptions
    , abilityBoosts = Dict.empty
    , skillIncreases = Dict.empty
    }


emptyAncestryOptions : AncestryOptions
emptyAncestryOptions =
    { abilityBoosts = Dict.empty
    , abilityFlaws = Dict.empty
    , voluntaryFlaw = False
    , heritage = Nothing
    , languages = []
    }


emptyBackgroundOptions : BackgroundOptions
emptyBackgroundOptions =
    { abilityBoosts = Dict.empty
    }


emptyClassOptions : ClassOptions
emptyClassOptions =
    { keyAbility = Nothing
    }


ancestryAbilityBoosts : Character -> List Ability.AbilityMod
ancestryAbilityBoosts character =
    case (character.ancestry, character.ancestryOptions.voluntaryFlaw, character.baseAbilities) of
        (Nothing, _, _) ->
            []

        (Just ancestry, False, Ability.Standard) ->
            ancestry.abilityBoosts ++ [Ability.free]

        (Just ancestry, True, Ability.Standard) ->
            ancestry.abilityBoosts ++ [Ability.free, Ability.free]

        (Just ancestry, False, Ability.Rolled _) ->
            ancestry.abilityBoosts

        (Just ancestry, True, Ability.Rolled _) ->
            ancestry.abilityBoosts ++ [Ability.free]


ancestryAbilityFlaws : Character -> List Ability.AbilityMod
ancestryAbilityFlaws character =
    case (character.ancestry, character.ancestryOptions.voluntaryFlaw) of
        (Nothing, _) ->
            []

        (Just ancestry, False) ->
            ancestry.abilityFlaws

        (Just ancestry, True) ->
            ancestry.abilityFlaws ++ [Ability.free, Ability.free]


backgroundAbilityBoosts : Character -> List Ability.AbilityMod
backgroundAbilityBoosts character =
    case (character.background, character.baseAbilities) of
        (Nothing, _) ->
            []

        (Just background, Ability.Standard) ->
            background.abilityBoosts ++ [Ability.free]

        (Just background, Ability.Rolled _) ->
            background.abilityBoosts


abilities : Int -> Character -> Ability.Abilities
abilities level character =
    Ability.calculatedAbilities
        character.baseAbilities
        ( List.concat
                [ Maybe.map .abilityFlaws character.ancestry
                    |> Maybe.withDefault []
                    |> Ability.fixedAbilityMods
                , Dict.values character.ancestryOptions.abilityFlaws
                ]
        )
        ( List.concat
            [ Maybe.map .abilityBoosts character.ancestry
                |> Maybe.withDefault []
                |> Ability.fixedAbilityMods
            , Dict.values character.ancestryOptions.abilityBoosts
            , Dict.values character.backgroundOptions.abilityBoosts
            , character.class
                |> Maybe.map .keyAbility
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
                |> Ability.fixedAbilityMods
            , case character.baseAbilities of
                Ability.Standard ->
                    character.classOptions.keyAbility
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
                Ability.Rolled _ ->
                    []
            , character.abilityBoosts
                |> Dict.filter (\k _ -> k == 1)
                |> Dict.values
                |> List.concat
            ]
        )
        ( character.abilityBoosts
            |> Dict.filter (\k _ -> k <= level && k > 1)
            |> Dict.values
            |> List.concat
        )


skillProficiencies : Int -> Character -> Dict String Proficiency
skillProficiencies level character =
    character.skillIncreases
        |> Dict.filter
            (\l _ -> level >= l)
        |> Dict.values
        |> List.concat
        |> List.sortBy .name
        |> List.Extra.group
        |> List.map
            (\(skill, list) ->
                ( skill.name
                , Proficiency.rank <| 1 + List.length list
                )
            )
        |> Dict.fromList


skillProficiency : String -> Int -> Character -> Proficiency
skillProficiency skill level character =
    Dict.get skill (skillProficiencies level character)
        |> Maybe.withDefault Proficiency.Untrained


level1SkillIncreases : Character -> Int
level1SkillIncreases character =
    List.sum
        [ character.class
            |> Maybe.map .skillIncreases
            |> Maybe.withDefault 0
        , abilities 1 character
            |> .int
            |> Ability.modifier
        , case (character.background, character.class) of
            (Just background, Just class) ->
                List.Extra.count
                    (\s -> List.member s background.skills)
                    class.skills
            (_, _) ->
                0
        ]


availableSkills : Int -> Character -> Dict String Data.Skill -> Dict String Data.Skill
availableSkills level character skills =
    Dict.filter
        (\_ skill ->
            skillProficiencies (level - 1) character
                |> Dict.get skill.name
                |> Maybe.withDefault Proficiency.Untrained
                |> Proficiency.compare (Proficiency.maxProficiency level)
                |> (==) GT
        )
        skills


asAncestryIn : Character -> Data.Ancestry -> Character
asAncestryIn character ancestry =
    { character
        | ancestry = Just ancestry
        , ancestryOptions = emptyAncestryOptions
    }


asAncestryOptionsIn : Character -> AncestryOptions -> Character
asAncestryOptionsIn character options =
    { character
        | ancestryOptions = options
    }


asBackgroundIn : Character -> Data.Background -> Character
asBackgroundIn character background =
    { character
        | background = Just background
        , backgroundOptions = emptyBackgroundOptions
    }


asBackgroundOptionsIn : Character -> BackgroundOptions -> Character
asBackgroundOptionsIn character options =
    { character
        | backgroundOptions = options
    }


asClassIn : Character -> Data.Class -> Character
asClassIn character class =
    { character
        | class = Just class
        , classOptions = emptyClassOptions
        , skillIncreases = Dict.empty
    }


asClassOptionsIn : Character -> ClassOptions -> Character
asClassOptionsIn character options =
    { character
        | classOptions = options
    }


asBaseAbilitiesIn : Character -> Ability.BaseAbilities -> Character
asBaseAbilitiesIn character baseAbilities =
    { character
        | baseAbilities = baseAbilities
        , ancestryOptions = emptyAncestryOptions
        , backgroundOptions = emptyBackgroundOptions
        , abilityBoosts = Dict.empty
    }
