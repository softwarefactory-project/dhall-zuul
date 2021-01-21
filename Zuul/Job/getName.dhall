{-|
Return the name of a job, defaulting `None` to `""`
-}
let Job = ./schema.dhall

let getName
    : Job.Type -> Text
    = \(job : Job.Type) -> job.name

let example0 = assert : getName Job::{ name = "job" } === "job"

in  getName
