let Zuul = ../package.dhall

let mqttReporter =
      \(stage : Text) ->
        Zuul.Pipeline.Reporter.mqtt
          { topic = "zuul/{pipeline}/${stage}/{project}/{branch}" }

let periodic =
      Zuul.Pipeline::{
      , name = "periodic"
      , manager = Zuul.Pipeline.independent
      , precedence = Some Zuul.Pipeline.low
      , post-review = Some True
      , description = Some "Jobs in this queue are triggered daily"
      , trigger = Some
          ( toMap
              { timer = Zuul.Pipeline.Trigger.timer [ { time = "0 0 * * *" } ] }
          )
      , start = Some (toMap { mqtt = mqttReporter "start" })
      , success = Some
          ( toMap
              { sqlreporter = Zuul.Pipeline.Reporter.sql
              , mqtt = mqttReporter "result"
              }
          )
      , failure = Some
          ( toMap
              { sqlreporter = Zuul.Pipeline.Reporter.sql
              , mqtt = mqttReporter "result"
              , smtp =
                  Zuul.Pipeline.Reporter.smtp
                    { from = "zuul@example.com"
                    , to = "root@localhost"
                    , subject =
                        "[Zuul] Job failed in periodic pipeline: {change.project}"
                    }
              }
          )
      }

in  Zuul.Pipeline.wrap [ periodic ]
