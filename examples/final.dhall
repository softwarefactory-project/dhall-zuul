let Zuul = env:DHALL_ZUUL ? ../package.dhall

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , check =
            Zuul.Project.Pipeline
              (Zuul.ProjectPipeline.mkSimple [ "test", "publish" ])
        }

in    Zuul.Job.wrap
        [ Zuul.Job::{ name = Some "test" }
        , Zuul.Job::{
          , name = Some "publish"
          , dependencies = Some [ Zuul.Job.Dependency.Name "test" ]
          }
        ]
    # Zuul.Project.wrap [ project ]
