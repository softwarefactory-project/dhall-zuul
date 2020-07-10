{- A function to wrap a list of Zuul.Job.Type -}
../../imports/map.dhall
  ./Type.dhall
  ../../typesUnion.dhall
  (\(job : ./Type.dhall) -> (../../typesUnion.dhall).Job { job })
