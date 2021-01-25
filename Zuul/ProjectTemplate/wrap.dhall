{-|
A function to wrap a list of Zuul.ProjectTemplate.Type
-}

let ProjectTemplate = { Type = ./Type.dhall }

let typesUnion = ../Resource.dhall

let wrap
    : List ProjectTemplate.Type → List typesUnion
    = ../../imports/map.dhall
        ProjectTemplate.Type
        typesUnion
        ( λ(projecttemplate : ProjectTemplate.Type) →
            typesUnion.ProjectTemplate { project-template = projecttemplate }
        )

in  wrap
