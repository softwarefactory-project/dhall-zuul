{-|
Set the parent of job
-}
let Job = ./schema.dhall

let setParent
    : Text -> Job.Type -> Job.Type
    = \(parent : Text) -> \(job : Job.Type) -> job // { parent = Some parent }

let example0 =
        assert
      :     setParent "base-test" Job::{ name = Some "job" }
        ===  Job::{ name = Some "job", parent = Some "base-test" }

in  setParent