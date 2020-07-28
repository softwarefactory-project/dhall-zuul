{-|
Construct a Project Map value using a pipeline
-}
let Project = { Union = ./union.dhall }

let Pipeline = { Type = ../ProjectPipeline/Type.dhall }

let Pipeline
    : Pipeline.Type -> Project.Union
    = (./union.dhall).Pipeline

in  Pipeline
