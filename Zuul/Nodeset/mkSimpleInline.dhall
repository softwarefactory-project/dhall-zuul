let Nodeset = { Union = ./union.dhall }

let mkSimpleInline
    : Text → Text → Optional Nodeset.Union
    = λ(name : Text) →
      λ(label-name : Text) →
        Some (./Inline.dhall (./mkSimple.dhall name label-name))

in  mkSimpleInline
