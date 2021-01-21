{-|
Modify a list of job by applying a function to each element
-}
let Job =
      { Type = ./Type.dhall
      , default = ./default.dhall
      , setParent = ./setParent.dhall
      }

let mapJob
    : (Job.Type -> Job.Type) -> List Job.Type -> List Job.Type
    = (../../imports/Prelude.dhall).List.map Job.Type Job.Type

let example0 =
        assert
      :     mapJob
              (Job.setParent "base-test")
              [ Job::{ name = "test" }, Job::{ name = "build" } ]
        ===  [ Job::{ name = "test", parent = Some "base-test" }
             , Job::{ name = "build", parent = Some "base-test" }
             ]

in  mapJob
