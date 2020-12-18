{-| An helper function to create a periodic pipeline -}
let Pipeline =
      { Type = ./Type.dhall
      , default = ./default.dhall
      , low = ./low.dhall
      , independent = ./independent.dhall
      , Trigger = ./Trigger/package.dhall
      , Reporter = ./Reporter/package.dhall
      }

in  \(frequency : Pipeline.Trigger.Timer.Frequency.Type) ->
    \(smtp-config : Pipeline.Reporter.Smtp) ->
    \(sql-name : Text) ->
      Pipeline::{
      , name = "periodic-${Pipeline.Trigger.Timer.Frequency.show frequency}"
      , manager = Pipeline.independent
      , precedence = Some Pipeline.low
      , post-review = Some True
      , description = Some
          "Jobs in this queue are triggered ${Pipeline.Trigger.Timer.Frequency.show
                                                frequency}"
      , trigger = Some
          ( toMap
              { timer =
                  Pipeline.Trigger.timer
                    [ { time = Pipeline.Trigger.Timer.Frequency.time frequency }
                    ]
              }
          )
      , success = Some
        [ { mapKey = sql-name, mapValue = Pipeline.Reporter.sql } ]
      , failure = Some
        [ { mapKey = sql-name, mapValue = Pipeline.Reporter.sql }
        , { mapKey = "smtp", mapValue = Pipeline.Reporter.smtp smtp-config }
        ]
      }
