{-
Return the name of a job, defaulting `None` to `""`
-}
let Job = ./schema.dhall

let getName
    : Job.Type -> Text
    = \(job : Job.Type) -> (../../imports/Prelude.dhall).Text.default job.name

let example0 = assert : getName Job::{ name = Some "job" } === "job"

let example1 = assert : getName Job::{=} === ""

in  getName
