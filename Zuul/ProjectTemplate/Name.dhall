{-|
Construct a ProjectTemplate Map value using a name
-}
let ProjectTemplate = { Union = ./Union.dhall }

let Name
    : Text -> ProjectTemplate.Union
    = ProjectTemplate.Union.Name

in  Name
