{- Consutrct a Project Pipeline (Map value) using a list of job names
-}
let Project = { Union = ./union.dhall }

let mkSimplePipeline
    : forall (job-names : List Text) -> Project.Union
    = \(job-names : List Text) ->
        ./Pipeline.dhall (../ProjectPipeline/mkSimple.dhall job-names)

in  mkSimplePipeline
