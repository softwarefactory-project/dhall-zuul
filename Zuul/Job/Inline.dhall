{-|
Construct a Job.Union using an inlined job.

   For example, to add a job to a pipeline configuration:

   ```
   [ Zuul.Job.Inline Zuul.Job::{ name = "job-name", attempts = Some 1 } ]
   ```

-}
let Job = { Type = ./Type.dhall, Union = ./Union.dhall }

let Inline
    : Job.Type -> Job.Union
    = \(job : Job.Type) ->
        Job.Union.Inline
          [ { mapKey = job.name, mapValue = job.(./InlineType.dhall) } ]

in  Inline
