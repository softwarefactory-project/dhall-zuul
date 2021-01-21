{-|
Construct a Job.Union using an inlined job.

   For example, to add a job to a pipeline configuration:

   ```
   [ Zuul.Job.WithOptions Zuul.Job::{ attempts = Some 1 } "job-name" ]
   ```

-}
let Job = { Type = ./Type.dhall, Union = ./union.dhall }

let Map = (../../imports/Prelude.dhall).Map.Type

let WithOptions
    : Job.Type -> Text -> Job.Union
    = \(job : Job.Type) ->
      \(job-name : Text) ->
        (./union.dhall).Inline
          [ { mapKey = job-name, mapValue = job.(./InlineType.dhall) } ]

in  WithOptions
