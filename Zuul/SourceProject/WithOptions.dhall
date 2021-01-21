\(project : ./Type.dhall) ->
\(name : Text) ->
  (./Union.dhall).Inline [ { mapKey = name, mapValue = project } ]
