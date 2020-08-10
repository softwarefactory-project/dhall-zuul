let Zuul = env:DHALL_ZUUL ? ../package.dhall

let ci-pipeline =
      Zuul.Project.Pipeline
        ( Zuul.ProjectPipeline.mkSimple
            [ "shake-factory-test", "shake-factory-docs" ]
        )

in  Zuul.Project.wrap [ toMap { check = ci-pipeline, gate = ci-pipeline } ]
