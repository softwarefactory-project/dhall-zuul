let Zuul = ../package.dhall

let gateTemplate =
      toMap
        { name = Zuul.ProjectTemplate.Name "gate-jobs"
        , gate =
            Zuul.ProjectTemplate.Pipeline
              (Zuul.ProjectPipeline.mkSimple [ "test", "publish" ])
        }

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , templates = Zuul.Project.Templates [ "gate-jobs" ]
        , check =
            Zuul.Project.Pipeline
              (Zuul.ProjectPipeline.mkSimple [ "test", "publish" ])
        }

in    Zuul.Job.wrap
        [ Zuul.Job::{ name = "test" }
        , Zuul.Job::{
          , name = "publish"
          , dependencies = Some [ Zuul.Job.Dependency.Name "test" ]
          }
        ]
    # Zuul.ProjectTemplate.wrap [ gateTemplate ]
    # Zuul.Project.wrap [ project ]
