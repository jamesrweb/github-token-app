module Main exposing (Flags, Model, Msg, main)

import Browser exposing (UrlRequest(..), application)
import Browser.Navigation exposing (Key, load, pushUrl)
import Github exposing (GithubUser, getGithubUser)
import Pages.Home
import Pages.NotFound
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Url exposing (Url)


type alias Flags =
    ()


type Msg
    = UrlRequested UrlRequest
    | UrlChanged Url
    | GotGithubUser (WebData GithubUser)


type alias Model =
    { user : WebData GithubUser
    , navigationKey : Key
    , route : Route
    }


main : Program Flags Model Msg
main =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url navigationKey =
    let
        route : Route
        route =
            Route.fromUrl url
    in
    ( Model RemoteData.Loading navigationKey route, getGithubUser GotGithubUser )


view : Model -> Browser.Document msg
view model =
    { title = "GH Token App"
    , body =
        case model.route of
            Home ->
                Pages.Home.view model.user

            NotFound ->
                Pages.NotFound.view
    }


update : Msg -> Model -> ( Model, Cmd msg )
update message model =
    case message of
        UrlChanged url ->
            let
                route : Route
                route =
                    Route.fromUrl url
            in
            ( { model | route = route }, Cmd.none )

        UrlRequested request ->
            case request of
                Internal url ->
                    let
                        uri : String
                        uri =
                            Url.toString url
                    in
                    ( model, pushUrl model.navigationKey uri )

                External url ->
                    ( model, load url )

        GotGithubUser response ->
            ( { model | user = response }, Cmd.none )


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none
