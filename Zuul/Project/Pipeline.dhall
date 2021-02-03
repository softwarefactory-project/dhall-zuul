{-|
Construct a Project Map value using a pipeline
-}
let Project = { Union = ./Union.dhall }

let PipelineConfig = { Type = ./PipelineConfig/Type.dhall }

let Pipeline
    : PipelineConfig.Type -> Project.Union
    = Project.Union.Pipeline

in  Pipeline
