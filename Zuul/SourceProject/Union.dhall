let SourceProject = ./schema.dhall

let Map = (../../imports/Prelude.dhall).Map.Type

in  < Name : Text | Inline : Map Text SourceProject.Type >
