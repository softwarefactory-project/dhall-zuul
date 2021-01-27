let Zuul = ../package.dhall

let mqttReporter =
      \(stage : Text) ->
        Zuul.Pipeline.Reporter.mqtt
          { topic = "zuul/{pipeline}/${stage}/{project}/{branch}" }

let smtp-config =
      { from = "zuul@example.com"
      , to = "root@localhost"
      , subject = "[Zuul] Job failed in periodic pipeline: {change.project}"
      }

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
              , smtp = Zuul.Pipeline.Reporter.smtp smtp-config
              }
          )
      }

let gate =
      Zuul.Pipeline::{
      , name = "gate"
      , manager = Zuul.Pipeline.Manager.dependent
      , require = Some
          ( toMap
              { `opendev.org` =
                  Zuul.Pipeline.Require.gerrit
                    Zuul.Pipeline.Require.Gerrit::{
                    , open = Some True
                    , approval = Some
                      [ Zuul.Pipeline.Require.Gerrit.Approval.username "zuul"
                      , Zuul.Pipeline.Require.Gerrit.Approval.vote "Verified" +1
                      ]
                    }
              }
          )
      }

let --| Using periodic helper function:
    hourly-periodic
    : Zuul.Pipeline.Type
    = Zuul.Pipeline.periodic
        Zuul.Pipeline.Trigger.Timer.Frequency.hourly
        smtp-config
        "sqlreporter"

let post
    : Zuul.Pipeline.Type
    = Zuul.Pipeline.post "gerrit" "sqlreporter"

let promote
    : Zuul.Pipeline.Type
    = Zuul.Pipeline.promote "gerrit" "sqlreporter"

in  Zuul.Pipeline.wrap [ gate, periodic, hourly-periodic, promote, post ]
