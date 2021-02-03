let Job = ../../Job/package.dhall

let ProjectPipeline = { Type = ./Type.dhall, default = ./default.dhall }

let mkSimple
    : forall (job-names : List Text) -> ProjectPipeline.Type
    = \(job-names : List Text) ->
        ProjectPipeline::{
        , jobs = ../../../imports/map.dhall Text Job.Union Job.Name job-names
        }

in  mkSimple
