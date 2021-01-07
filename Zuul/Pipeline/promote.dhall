{-| An helper function to create a promote pipeline -}
let Pipeline =
      { Type = ./Type.dhall
      , default = ./default.dhall
      , low = ./low.dhall
      , supercedent = ./supercedent.dhall
      , high = ./high.dhall
      , Trigger = ./Trigger/package.dhall
      , Reporter = ./Reporter/package.dhall
      }

in  \(gerrit-name : Text) ->
    \(sql-name : Text) ->
      let reporter =
            Some
              [ { mapKey = sql-name, mapValue = Pipeline.Reporter.sql }
              , { mapKey = gerrit-name
                , mapValue =
                    Pipeline.Reporter.gerrit Pipeline.Reporter.Gerrit.empty
                }
              ]

      in  Pipeline::{
          , name = "promote"
          , description = Some
              "This pipeline runs jobs that operate after each change is merged."
          , manager = Pipeline.supercedent
          , precedence = Some Pipeline.high
          , post-review = Some True
          , trigger = Some
            [ { mapKey = gerrit-name
              , mapValue = Pipeline.Trigger.Gerrit.promote
              }
            ]
          , success = reporter
          , failure = reporter
          }
