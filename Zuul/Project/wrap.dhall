{- A function to wrap a list of Zuul.Project.Type -}

let Project = { Type = ./Type.dhall }

let typesUnion = ../../typesUnion.dhall

let wrap
    : List Project.Type -> List typesUnion
    = ../../imports/map.dhall
        Project.Type
        typesUnion
        (\(project : Project.Type) -> typesUnion.Project { project })

in  wrap
