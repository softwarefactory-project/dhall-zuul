let Zuul = env:DHALL_ZUUL ? ../package.dhall

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , check = Zuul.jobNamesToPipeline [ "test", "publish" ]
        }

in    Zuul.Job.pack
        [ Zuul.Job::{ name = Some "test" }
        , Zuul.Job::{ name = Some "publish" }
        ]
    # Zuul.Project.pack [ project ]
