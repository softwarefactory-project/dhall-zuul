{-|
Construct a Project Map value using a name
-}
let Project = { Union = ./Union.dhall }

let Name
    : Text -> Project.Union
    = Project.Union.Name

in  Name
