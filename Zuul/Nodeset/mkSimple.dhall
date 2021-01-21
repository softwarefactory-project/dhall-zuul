{-|
Create a nodeset with a single node named after the label
-}
let Nodeset = ./schema.dhall

let mkSimple
    : Text -> Nodeset.Type
    = \(name : Text) -> { name, nodes = [ { name, label = name } ] }

in  mkSimple
