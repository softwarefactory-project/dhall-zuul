{-|
Create a nodeset with a single node named after the label
-}
let Nodeset = ./schema.dhall

let mkSimple
    : Text → Text → Nodeset.Type
    = λ(name : Text) →
      λ(label-name : Text) →
        Nodeset::{ name, nodes = [ { name = label-name, label = label-name } ] }

in  mkSimple
