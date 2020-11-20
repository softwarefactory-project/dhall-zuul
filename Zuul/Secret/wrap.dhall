{-|
A function to wrap a list of Zuul.Secret.Type
-}

let Secret = { Type = ./Type.dhall }

let typesUnion = ../Resource.dhall

let wrap
    : List Secret.Type -> List typesUnion
    = ../../imports/map.dhall
        Secret.Type
        typesUnion
        (\(secret : Secret.Type) -> typesUnion.Secret { secret })

in  wrap
