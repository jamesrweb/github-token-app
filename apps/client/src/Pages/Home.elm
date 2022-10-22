module Pages.Home exposing (view)

import Github exposing (GithubUser(..))
import Html exposing (Html)
import Html.Attributes exposing (src)
import RemoteData exposing (RemoteData(..), WebData)
import Url


view : WebData GithubUser -> List (Html msg)
view request =
    case request of
        Success (GithubUser user) ->
            let
                avatar : Html msg
                avatar =
                    case user.avatar of
                        Just url ->
                            Html.img [ Url.toString url |> src ] []

                        Nothing ->
                            Html.text ""
            in
            [ avatar
            , Html.dl []
                [ Html.dt [] [ Html.text "Username" ]
                , Html.dd [] [ "@" ++ user.username |> Html.text ]
                , Html.dt [] [ Html.text "Name" ]
                , Html.dd [] [ Html.text user.name ]
                , Html.dt [] [ Html.text "Location" ]
                , Html.dd [] [ Html.text user.location ]
                , Html.dt [] [ Html.text "Last updated" ]
                , Html.dd [] [ Html.text user.lastUpdated ]
                ]
            ]

        Loading ->
            [ Html.text "Loading user information..." ]

        NotAsked ->
            [ Html.text "Loading the user information has not began yet..." ]

        Failure _ ->
            [ Html.text "Failed to load user information, try again later." ]
