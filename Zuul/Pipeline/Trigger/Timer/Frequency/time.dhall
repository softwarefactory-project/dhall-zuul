let time
    : ./Type.dhall -> Text
    = \(frequency : ./Type.dhall) ->
        merge
          { hourly = "0 * * * *"
          , daily = "0 0 * * * *"
          , weekly = "0 8 * * 6"
          , monthly = "0 0 1 * *"
          }
          frequency

in  time
