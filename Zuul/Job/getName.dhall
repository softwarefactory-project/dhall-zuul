{-|
Return the name of a job, defaulting `None` to `""`
-}
let Job = { Type = ./Type.dhall, default = ./default.dhall }

let getName
    : Job.Type -> Text
    = \(job : Job.Type) -> job.name

let example0 = assert : getName Job::{ name = "job" } === "job"

in  getName
