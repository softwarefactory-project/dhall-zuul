{-|
A function to wrap a list of Zuul.Job.Type
-}

let Job = { Type = ./Type.dhall }

let typesUnion = ../../typesUnion.dhall

let wrap
    : List Job.Type -> List typesUnion
    = ../../imports/map.dhall
        Job.Type
        typesUnion
        (\(job : Job.Type) -> typesUnion.Job { job })

in  wrap
