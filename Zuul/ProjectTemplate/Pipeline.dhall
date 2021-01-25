{-|
Construct a Project Map value using a pipeline
-}
let Project = { Union = ./Union.dhall }

let Pipeline = { Type = ../ProjectPipeline/Type.dhall }

let Pipeline
    : Pipeline.Type -> Project.Union
    = Project.Union.Pipeline

in  Pipeline
