{-|
Consutrct a Project Pipeline (Map value) using a list of job names
-}
let ProjectTemplate = { Union = ./Union.dhall }

let mkSimplePipeline
    : ∀(job-names : List Text) → ProjectTemplate.Union
    = λ(job-names : List Text) →
        ./Pipeline.dhall (../ProjectPipeline/mkSimple.dhall job-names)

in  mkSimplePipeline
