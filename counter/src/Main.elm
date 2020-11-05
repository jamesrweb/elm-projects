module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, h1, img, p, text)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement
    | Reset


init : Model
init =
    0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            if model > 0 then
                model - 1

            else
                0

        Reset ->
            0


copy : String
copy =
    "An example application for a counter which can be incremented or decremented using Elm."


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ img [ src "./logo.svg", alt "", class "logo" ] []
        , h1 [] [ text "Counter App" ]
        , p [ class "description" ] [ text copy ]
        , div [ class "counter" ]
            [ p [ class "counter__output" ] [ text ("Current value: " ++ String.fromInt model) ]
            , div [ class "button-group" ]
                [ button [ onClick Increment, class "button" ] [ text "Increment (+1)" ]
                , button [ onClick Decrement, class "button" ] [ text "Decrement (-1)" ]
                , button [ onClick Reset, class "button" ] [ text "Reset" ]
                ]
            ]
        ]


main : Program () Model Msg
main =
    sandbox { init = init, update = update, view = view }
