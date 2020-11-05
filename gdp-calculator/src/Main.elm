module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, div, input, label, p, text)
import Html.Attributes exposing (value, type_)
import Html.Events exposing (onInput)


type Msg
    = ConsumerSpending String
    | GovernmentSpending String
    | Investment String
    | Imports String
    | Exports String


type alias Model =
    { c : Int
    , i : Int
    , g : Int
    , x : Int
    , m : Int
    }


init : Model
init =
    { c = 0
    , i = 0
    , g = 0
    , x = 0
    , m = 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ConsumerSpending value ->
            { model | c = floatFrom value }

        GovernmentSpending value ->
            { model | g = floatFrom value }

        Investment value ->
            { model | i = floatFrom value }

        Exports value ->
            { model | x = floatFrom value }

        Imports value ->
            { model | m = floatFrom value }


view : Model -> Html Msg
view model =
    div []
        [ field "Consumption" model.c ConsumerSpending
        , field "Investment" model.i Investment
        , field "Goverment Spending" model.g GovernmentSpending
        , field "Exports" model.x Exports
        , field "Imports" model.m Imports
        , p [] [ text ("Current GDP: " ++ String.fromInt (calculateGDP model)) ]
        ]


main : Program () Model Msg
main =
    sandbox { init = init, update = update, view = view }


floatFrom : String -> Int
floatFrom value =
    Maybe.withDefault 0 (String.toInt value)


field : String -> Int -> (String -> Msg) -> Html Msg
field title content action =
    label []
        [ text title
        , input
            [ onInput action
            , value (String.fromInt content),
            type_ "text"
            ]
            []
        ]


calculateGDP : Model -> Int
calculateGDP model =
    model.c + model.i + model.g + (model.x - model.m)
