let Zuul = env:DHALL_ZUUL ? ../package.dhall

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , check = Zuul.Project.mkSimpleInline [ "test", "publish" ]
        }

in    Zuul.Job.wrap
        [ Zuul.Job::{ name = Some "test" }
        , Zuul.Job::{ name = Some "publish" }
        ]
    # Zuul.Project.wrap [ project ]
