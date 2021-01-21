{-|
Construct a Job.Union using an inlined job.

   For example, to add a job to a pipeline configuration:

   ```
   [ Zuul.Job.Inline (toMap { job-name = Zuul.Job::{ attempts = Some 1 } }) ]
   ```

-}
let Job = { InlineType = ./InlineType.dhall, Union = ./union.dhall }

let Map = (../../imports/Prelude.dhall).Map.Type

let Inline
    : Map Text Job.InlineType -> Job.Union
    = (./union.dhall).Inline

in  Inline
