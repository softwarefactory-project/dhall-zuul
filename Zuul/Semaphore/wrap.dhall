{-|
A function to wrap a list of Zuul.Semaphore.Type
-}

let Semaphore = { Type = ./Type.dhall }

let typesUnion = ../Resource.dhall

let wrap
    : List Semaphore.Type -> List typesUnion
    = ../../imports/map.dhall
        Semaphore.Type
        typesUnion
        (\(semaphore : Semaphore.Type) -> typesUnion.Semaphore { semaphore })

in  wrap
