{-|
Construct a ProjectPipeline Map value using a pipeline
-}
let Project = { Union = ./Union.dhall }

let Pipeline = { Type = ../Project/PipelineConfig/Type.dhall }

let Pipeline
    : Pipeline.Type -> Project.Union
    = Project.Union.Pipeline

in  Pipeline
