let Zuul = env:DHALL_ZUUL ? ../package.dhall

let ci-pipeline =
      Zuul.Project.Pipeline
        Zuul.ProjectPipeline::{
        , jobs =
          [ Zuul.Job.Inline
              ( toMap
                  { dhall-diff = Zuul.Job::{
                    , nodeset = Zuul.Nodeset.mkSimpleInline "pod-dhall-1-33"
                    }
                  }
              )
          ]
        }

in  Zuul.Project.wrap [ toMap { check = ci-pipeline, gate = ci-pipeline } ]
