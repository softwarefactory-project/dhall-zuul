let Zuul =
        ./../package.dhall sha256:a36bcf3f464235b1039d297c26344022bf797a41a00222b324bda579744bc342
      ? https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall sha256:a36bcf3f464235b1039d297c26344022bf797a41a00222b324bda579744bc342
      ? https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall

let Zuul = ./../package.dhall

let Job =
      Zuul.Job::{
      , name = Some "bench-job"
      , vars = Some [ { mapKey = "my_var", mapValue = "val" } ]
      }

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
