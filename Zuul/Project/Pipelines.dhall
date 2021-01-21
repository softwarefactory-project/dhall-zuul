{-|
Construct a Project Map value from ProjectPipeline MAp
-}
let ProjectPipeline = ../ProjectPipeline/package.dhall

let Map = (../../imports/Prelude.dhall).Map

let Pipelines
    : Map.Type Text ProjectPipeline.Type -> Map.Type Text ./Union.dhall
    = Map.map Text ProjectPipeline.Type ./Union.dhall ./Pipeline.dhall

in  Pipelines
