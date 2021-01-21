let Job = ../Job/package.dhall

let ProjectPipeline = ./schema.dhall

let mkSimple
    : forall (job-names : List Text) -> ProjectPipeline.Type
    = \(job-names : List Text) ->
        ProjectPipeline::{
        , jobs = ../../imports/map.dhall Text Job.Union Job.Name job-names
        }

in  mkSimple
