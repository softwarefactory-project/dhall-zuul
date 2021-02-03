{-|
Create a project pipeline from a list of jobs
-}
let ProjectPipeline = { Type = ./Type.dhall, default = ./default.dhall }

let Job = ../../Job/package.dhall

let mkSimpleJobs
    : forall (jobs : List Job.Type) -> ProjectPipeline.Type
    = \(jobs : List Job.Type) ->
        ./mkSimple.dhall (Job.map Text Job.getName jobs)

in  mkSimpleJobs
