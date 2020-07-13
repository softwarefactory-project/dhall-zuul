let ProjectPipeline = ./schema.dhall

let mkSimple
    : forall (job-names : List Text) -> ProjectPipeline.Type
    = \(job-names : List Text) ->
        ProjectPipeline::{
        , jobs =
            ../../imports/map.dhall
              Text
              ../Job/union.dhall
              ../Job/Name.dhall
              job-names
        }

in  mkSimple
