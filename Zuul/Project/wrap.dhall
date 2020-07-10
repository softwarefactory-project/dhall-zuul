{- A function to wrap a list of Zuul.Project.Type -}
../../imports/map.dhall
  ./Type.dhall
  ../../typesUnion.dhall
  (\(project : ./Type.dhall) -> (../../typesUnion.dhall).Project { project })
