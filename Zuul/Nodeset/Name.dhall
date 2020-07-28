{-|
Construct a Nodeset.Union using a name
-}
let Nodeset = { Union = ./union.dhall }

let Name
    : Text -> Nodeset.Union
    = (./union.dhall).Name

in  Name
