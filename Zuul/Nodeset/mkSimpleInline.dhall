let Nodeset = { Union = ./union.dhall }

let mkSimpleInline
    : Text -> Optional Nodeset.Union
    = \(label-name : Text) ->
        Some (./Inline.dhall (./mkSimple.dhall label-name))

in  mkSimpleInline
