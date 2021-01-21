let Zuul = ../package.dhall

let Job = Zuul.Job::{ name = "bench-job" }

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
