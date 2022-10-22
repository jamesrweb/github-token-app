module Github exposing (GithubUser(..), getGithubUser)

import Http
import Json.Decode as Decode exposing (Decoder)
import RemoteData exposing (RemoteData)
import Url exposing (Url)


type GithubUser
    = GithubUser
        { avatar : Maybe Url
        , lastUpdated : String
        , location : String
        , name : String
        , username : String
        }


getGithubUser : (RemoteData Http.Error GithubUser -> msg) -> Cmd msg
getGithubUser message =
    Http.get
        { url = "/auth"
        , expect = Http.expectJson (RemoteData.fromResult >> message) decodeGithubUser
        }


decodeGithubUser : Decoder GithubUser
decodeGithubUser =
    let
        toGithubUser : Maybe Url -> String -> String -> String -> String -> GithubUser
        toGithubUser avatar lastUpdated location name username =
            GithubUser
                { avatar = avatar
                , lastUpdated = lastUpdated
                , location = location
                , name = name
                , username = username
                }
    in
    Decode.map5 toGithubUser
        (Decode.field "avatar" Decode.string |> Decode.andThen (Url.fromString >> Decode.succeed))
        (Decode.field "lastUpdated" Decode.string)
        (Decode.field "location" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "username" Decode.string)
