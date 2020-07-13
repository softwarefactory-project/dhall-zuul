{-
Transform a list of job by applying a function to each element
-}
let Job = ./Type.dhall

let map
    : forall (a : Type) -> (Job -> a) -> List Job -> List a
    = (../../imports/Prelude.dhall).List.map ./Type.dhall

in  map
