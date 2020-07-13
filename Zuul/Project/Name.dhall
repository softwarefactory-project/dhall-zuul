{- Construct a Project Map value using a name
-}
let Project = { Union = ./union.dhall }

let Name
    : Text -> Project.Union
    = (./union.dhall).Name

in  Name
