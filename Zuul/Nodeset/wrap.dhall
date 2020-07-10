{- A function to wrap a list of Zuul.Nodeset.Type -}
../../imports/map.dhall
  ./Type.dhall
  ../../typesUnion.dhall
  (\(nodeset : ./Type.dhall) -> (../../typesUnion.dhall).Nodeset { nodeset })
