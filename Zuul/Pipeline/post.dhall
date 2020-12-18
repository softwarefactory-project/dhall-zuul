{-| An helper function to create a post pipeline -}
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
      Pipeline::{
      , name = "post"
      , description = Some
          "This pipeline runs jobs that operate after each change is merged."
      , manager = Pipeline.supercedent
      , precedence = Some Pipeline.high
      , post-review = Some True
      , trigger = Some
        [ { mapKey = gerrit-name, mapValue = Pipeline.Trigger.Gerrit.post } ]
      , success = Some
        [ { mapKey = sql-name, mapValue = Pipeline.Reporter.sql } ]
      , failure = Some
        [ { mapKey = sql-name, mapValue = Pipeline.Reporter.sql } ]
      }
