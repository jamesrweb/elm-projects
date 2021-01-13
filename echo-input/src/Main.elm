module Main exposing (main)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (for, id, type_)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { message : String
    }


init : Model
init =
    { message = "" }


type Msg
    = Message String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Message message ->
            { model | message = message }


view : Model -> Html Msg
view model =
    div []
        [ label [ for "input" ] [ text "Enter a message:" ]
        , br [] []
        , input [ onInput Message, id "input" ] []
        , p [] [ text model.message ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
