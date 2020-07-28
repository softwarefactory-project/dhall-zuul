{-|
Build a list of job by adding a version number to the job name
-}
let Job = ./schema.dhall

let replicate
    : Natural -> Job.Type -> List Job.Type
    = \(count : Natural) ->
      \(job : Job.Type) ->
        (../../imports/Prelude.dhall).List.generate
          count
          Job.Type
          ( \(idx : Natural) ->
                  job
              //  { name = Some
                      (./getName.dhall job ++ "-" ++ Natural/show (idx + 1))
                  }
          )

let example0 =
        assert
      :     replicate 3 Job::{ name = Some "job" }
        ===  [ Job::{ name = Some "job-1" }
             , Job::{ name = Some "job-2" }
             , Job::{ name = Some "job-3" }
             ]

in  replicate
