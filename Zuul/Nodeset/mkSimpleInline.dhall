let Nodeset = { Union = ./Union.dhall }

let mkSimpleInline
    : Text -> Optional Nodeset.Union
    = \(label-name : Text) ->
        Some (./Inline.dhall (./mkSimple.dhall label-name))

in  mkSimpleInline
