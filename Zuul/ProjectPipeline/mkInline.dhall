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
                    [ { mapKey =
                          merge
                            { None = "", Some = \(name : Text) -> name }
                            job.name
                      , mapValue = job // { name = None Text }
                      }
                    ]
              )
              jobs
        }

in  mkInline
