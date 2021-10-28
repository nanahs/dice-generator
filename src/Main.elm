module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Random


type alias Model =
    { die1 : Int
    , die2 : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { die1 = 1
      , die2 = 1
      }
    , Random.generate RecievedNewNumber (Random.pair (Random.int 1 6) (Random.int 1 6))
    )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div [ Attributes.class "flex flex-col items-center mt-14 mx-auto gap-y-2" ]
        [ Html.div [ Attributes.class "flex gap-x-2" ]
            [ viewDie model.die1
            , viewDie model.die2
            ]
        , viewButton
        ]


viewDie : Int -> Html Msg
viewDie numPips =
    Html.div [ Attributes.class "border-4 border-black w-64 h-64 rounded-lg flex justify-center items-center" ]
        [ viewPips numPips
        ]


viewPips : Int -> Html Msg
viewPips numPips =
    pipToList numPips
        |> Maybe.map (\pips -> Html.div [ Attributes.class "grid grid-cols-3" ] pips)
        |> Maybe.withDefault (Html.text "")


viewPip : Html Msg
viewPip =
    Html.div
        [ Attributes.class "text-6xl flex items-center justify-center w-12 h-12"
        ]
        [ Html.text "·" ]


viewEmptyPip : Html Msg
viewEmptyPip =
    Html.div [ Attributes.class "text-6xl flex items-center justify-center w-12 h-12" ] []


viewButton : Html Msg
viewButton =
    Html.button [ Events.onClick ClickedNewNumber ]
        [ Html.div [ Attributes.class "bg-green-200 py-1 px-2 rounded-md" ] [ Html.text "New Die Please!" ]
        ]


pipToList : Int -> Maybe (List (Html Msg))
pipToList numPips =
    case numPips of
        1 ->
            Just [ viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip ]

        2 ->
            Just [ viewPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewPip ]

        3 ->
            Just [ viewPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewPip ]

        4 ->
            Just [ viewPip, viewEmptyPip, viewPip, viewEmptyPip, viewEmptyPip, viewEmptyPip, viewPip, viewEmptyPip, viewPip ]

        5 ->
            Just [ viewPip, viewEmptyPip, viewPip, viewEmptyPip, viewPip, viewEmptyPip, viewPip, viewEmptyPip, viewPip ]

        6 ->
            Just [ viewPip, viewEmptyPip, viewPip, viewPip, viewEmptyPip, viewPip, viewPip, viewEmptyPip, viewPip ]

        _ ->
            Nothing



-- UPDATE


type Msg
    = ClickedNewNumber
    | RecievedNewNumber ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedNewNumber ->
            ( model
            , Random.generate RecievedNewNumber (Random.pair (Random.int 1 6) (Random.int 1 6))
            )

        RecievedNewNumber ( first, second ) ->
            ( { model | die1 = first, die2 = second }
            , Cmd.none
            )


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> init
        , update = update
        , view =
            \model ->
                { title = "die generator"
                , body = [ view model ]
                }
        , subscriptions = \_ -> Sub.none
        }
