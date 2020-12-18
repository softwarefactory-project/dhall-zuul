{-|
A function to wrap a list of Zuul.Pipeline.Type
-}

let Pipeline = { Type = ./Type.dhall }

let typesUnion = ../Resource.dhall

let wrap
    : List Pipeline.Type -> List typesUnion
    = ../../imports/map.dhall
        Pipeline.Type
        typesUnion
        (\(pipeline : Pipeline.Type) -> typesUnion.Pipeline { pipeline })

in  wrap
