let Zuul =
        https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall sha256:6ba224314853608af08a4c2886f7b97f8e7c80b1c48c2f9f5b32ea6446f3bb15
      ? https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall

let Job = Zuul.Job::{ name = Some "bench-job" }

let Jobs =
      Zuul.Job.mapJob
        (Zuul.Job.setParent "bench-job")
        (Zuul.Job.replicate 3 Job)

in    Zuul.Job.wrap ([ Job ] # Jobs)
    # Zuul.Project.wrap
        [ toMap
            { check =
                Zuul.Project.mkSimplePipeline
                  (Zuul.Job.map Text Zuul.Job.getName Jobs)
            }
        ]
