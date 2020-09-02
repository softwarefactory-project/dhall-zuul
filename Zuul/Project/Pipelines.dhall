{-|
Construct a Project Map value from ProjectPipeline MAp
-}
let ProjectPipeline = ../ProjectPipeline/package.dhall

let Map = (../../imports/Prelude.dhall).Map

let Pipelines
    : Map.Type Text ProjectPipeline.Type -> Map.Type Text ./union.dhall
    = Map.map Text ProjectPipeline.Type ./union.dhall ./Pipeline.dhall

in  Pipelines
