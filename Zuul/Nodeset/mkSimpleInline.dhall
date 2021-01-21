let Nodeset = { Union = ./union.dhall }

let mkSimpleInline
    : Text → Optional Nodeset.Union
    = λ(label-name : Text) → Some (./Inline.dhall (./mkSimple.dhall label-name))

in  mkSimpleInline
