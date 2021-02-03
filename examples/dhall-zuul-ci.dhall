let Zuul = ../package.dhall

let ci-pipeline =
      Zuul.Project.Pipeline
        ( Zuul.Project.PipelineConfig.mkSimple
            [ "shake-factory-test", "shake-factory-docs" ]
        )

in  Zuul.Project.wrap [ toMap { check = ci-pipeline, gate = ci-pipeline } ]
