let ProjectPipeline = ./schema.dhall

let Job = ../Job/package.dhall

let mkInline
    : forall (jobs : List Job.Type) -> ProjectPipeline.Type
    = \(jobs : List Job.Type) ->
        ProjectPipeline::{
        , jobs = ../../imports/map.dhall Job.Type Job.Union Job.Inline jobs
        }

in  mkInline
