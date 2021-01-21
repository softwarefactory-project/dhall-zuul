{-|
Construct a Nodeset.Union using a name
-}
let Nodeset = { Union = ./Union.dhall }

let Name
    : Text -> Nodeset.Union
    = Nodeset.Union.Name

in  Name
