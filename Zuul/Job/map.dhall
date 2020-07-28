{-|
Transform a list of job by applying a function to each element
-}
let Job =
      { Type = ./Type.dhall
      , default = ./default.dhall
      , getName = ./getName.dhall
      }

let map
    : forall (a : Type) -> (Job.Type -> a) -> List Job.Type -> List a
    = (../../imports/Prelude.dhall).List.map Job.Type

let example0 =
        assert
      :     map
              Text
              Job.getName
              [ Job::{ name = Some "test" }, Job::{ name = Some "build" } ]
        ===  [ "test", "build" ]

in  map
