module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Set exposing (Set)
import Task exposing (fail)



---- MODEL ----


type alias Guesses =
    Set String


type alias Model =
    { phrase : String, guesses : Guesses }


init : ( Model, Cmd Msg )
init =
    ( { phrase = "testing 123"
      , guesses = Set.empty
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | Guess String
    | Restart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Guess char ->
            ( { model | guesses = Set.insert char model.guesses }, Cmd.none )

        Restart ->
            ( { model | guesses = Set.empty }, Cmd.none )



---- VIEW ----


phraseHtml : Model -> Html Msg
phraseHtml model =
    model.phrase
        |> String.split ""
        |> List.map
            (\char ->
                if char == " " then
                    "\u{00A0}"

                else if Set.member char model.guesses then
                    char

                else
                    "_"
            )
        |> List.intersperse " "
        |> List.map (\char -> span [] [ text char ])
        |> div []


inputGuessButtonsHtml : Html Msg
inputGuessButtonsHtml =
    let
        numbers =
            List.range 49 57

        letters =
            List.range 97 122
    in
    List.append numbers letters
        |> List.map (\code -> Char.fromCode code)
        |> List.map
            (\letter ->
                button
                    [ class "button", onClick <| Guess (String.fromChar letter) ]
                    [ text (String.fromChar letter) ]
            )
        |> div [ class "guess-button-container" ]


phraseSet : Model -> Set String
phraseSet model =
    model.phrase
        |> String.split ""
        |> Set.fromList


failuresHtml : Model -> Html Msg
failuresHtml model =
    let
        failures =
            model.guesses
                |> Set.toList
                |> List.filter
                    (\char ->
                        not <|
                            Set.member char (phraseSet model)
                    )
    in
    if Set.isEmpty model.guesses then
        div [ class "failures" ]
            [ h2 [ class "title" ] [ text "Incorrect entries" ]
            , span [] [ text "Make a guess!" ]
            ]

    else if List.length failures == 0 then
        div [ class "failures" ]
            [ h2 [ class "title" ] [ text "Incorrect entries" ]
            , span [] [ text "Going good so far.." ]
            ]

    else
        div [ class "failures" ]
            [ h2 [ class "title" ] [ text "Incorrect entries" ]
            , div [] [ text (String.join ", " failures) ]
            ]


controlsHtml : Html Msg
controlsHtml =
    div [ class "controls-container" ]
        [ button [ class "button", onClick Restart ] [ text "Restart game" ]
        ]


gameBoardHtml : Model -> Html Msg
gameBoardHtml model =
    div [ class "game-container" ]
        [ inputGuessButtonsHtml
        , failuresHtml model
        , controlsHtml
        ]


winHtml : Model -> Html Msg
winHtml model =
    let
        current =
            model.guesses
                |> Set.toList
                |> List.filter
                    (\char -> Set.member char (phraseSet model))
                |> List.length

        target =
            String.toList model.phrase
                |> Set.fromList
                |> Set.toList
                |> List.filter (\char -> Char.isAlphaNum char)
                |> List.length

        winCondition =
            current == target
    in
    if winCondition then
        span [] [ text "You won!" ]

    else
        span [] []


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [ class "title" ] [ text "Hangman" ]
        , phraseHtml model
        , winHtml model
        , gameBoardHtml model
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = always init
        , update = update
        , subscriptions = always Sub.none
        }
