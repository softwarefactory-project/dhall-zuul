{ Type = ../types/project.dhall
, default = ../defaults/project.dhall
, Box = ../boxed-types/project.dhall
, Name = (../unions/pipeline-or-name.dhall).Name
, Pipeline = (../unions/pipeline-or-name.dhall).Pipeline
, pack =
    ../functions/map.dhall
      ../types/project.dhall
      ../typesUnion.dhall
      ( \(project : ../types/project.dhall) ->
          (../typesUnion.dhall).Project { project }
      )
}
