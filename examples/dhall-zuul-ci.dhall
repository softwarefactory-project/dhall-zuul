let Zuul = env:DHALL_ZUUL ? ../package.dhall

let ci-pipeline =
      Zuul.Project.Pipeline
        Zuul.ProjectPipeline::{
        , jobs =
          [ Zuul.JobOrString.Job
              ( toMap
                  { dhall-diff = Zuul.Job::{
                    , nodeset = Some (Zuul.labelToNodeset "pod-dhall-1-33")
                    }
                  }
              )
          ]
        }

in  Zuul.Project.pack [ toMap { check = ci-pipeline, gate = ci-pipeline } ]
