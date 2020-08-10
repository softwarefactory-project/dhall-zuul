\(project : ./Type.dhall) ->
\(name : Text) ->
  (./union.dhall).Inline [ { mapKey = name, mapValue = project } ]
