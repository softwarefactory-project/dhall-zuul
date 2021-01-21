{-|
Construct a Job.Union using a name
-}
let Job = { Union = ./Union.dhall }

let Name
    : Text -> Job.Union
    = Job.Union.Name

in  Name
