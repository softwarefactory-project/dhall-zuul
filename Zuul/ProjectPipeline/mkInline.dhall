let ProjectPipeline = ./schema.dhall

let Job = ../Job/package.dhall

let mkInline
    : forall (jobs : List Job.Type) -> ProjectPipeline.Type
    = \(jobs : List Job.Type) ->
        ProjectPipeline::{
        , jobs =
            ../../imports/map.dhall
              Job.Type
              ../Job/union.dhall
              ( \(job : Job.Type) ->
                  ../Job/Inline.dhall
                    [ { mapKey = job.name, mapValue = job.(Job.InlineType) } ]
              )
              jobs
        }

in  mkInline
