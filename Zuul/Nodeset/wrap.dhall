{- A function to wrap a list of Zuul.Nodeset.Type -}

let Nodeset = { Type = ./Type.dhall }

let typesUnion = ../../typesUnion.dhall

let wrap
    : List Nodeset.Type -> List typesUnion
    = ../../imports/map.dhall
        Nodeset.Type
        typesUnion
        (\(nodeset : Nodeset.Type) -> typesUnion.Nodeset { nodeset })

in  wrap
