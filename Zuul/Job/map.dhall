{-
Transform a list of job by applying a function to each element
-}
let Job = ./schema.dhall

let map
    : forall (a : Type) -> (Job.Type -> a) -> List Job.Type -> List a
    = (../../imports/Prelude.dhall).List.map Job.Type

in  map
