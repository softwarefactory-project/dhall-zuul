{-|
Build a list of job by adding a version number to the job name
-}
let Job = { Type = ./Type.dhall, default = ./default.dhall }

let replicate
    : Natural -> Job.Type -> List Job.Type
    = \(count : Natural) ->
      \(job : Job.Type) ->
        (../../imports/Prelude.dhall).List.generate
          count
          Job.Type
          ( \(idx : Natural) ->
              job // { name = job.name ++ "-" ++ Natural/show (idx + 1) }
          )

let example0 =
        assert
      :     replicate 3 Job::{ name = "job" }
        ===  [ Job::{ name = "job-1" }
             , Job::{ name = "job-2" }
             , Job::{ name = "job-3" }
             ]

in  replicate
