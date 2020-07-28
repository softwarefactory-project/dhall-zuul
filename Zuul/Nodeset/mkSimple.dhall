{-|
Create a nodeset with a single node named after the label
-}
let Nodeset = ./schema.dhall

let mkSimple
    : Text -> Nodeset.Type
    = \(label-name : Text) ->
        Nodeset::{ nodes = [ { name = label-name, label = label-name } ] }

in  mkSimple
