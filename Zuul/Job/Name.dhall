{-|
Construct a Job.Union using a name
-}
let Job = { Union = ./union.dhall }

let Name
    : Text -> Job.Union
    = (./union.dhall).Name

in  Name
