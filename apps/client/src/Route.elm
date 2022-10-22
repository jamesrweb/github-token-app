module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser exposing (Parser, map, oneOf, parse, top)


type Route
    = Home
    | NotFound


parseRoute : Parser (Route -> a) a
parseRoute =
    oneOf
        [ map Home top
        ]


fromUrl : Url -> Route
fromUrl url =
    parse parseRoute url |> Maybe.withDefault NotFound
