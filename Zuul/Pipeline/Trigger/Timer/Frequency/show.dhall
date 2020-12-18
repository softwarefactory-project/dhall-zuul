let show
    : ./Type.dhall -> Text
    = \(frequency : ./Type.dhall) ->
        merge
          { hourly = "hourly"
          , daily = "daily"
          , weekly = "weekly"
          , monthly = "monthly"
          }
          frequency

in  show
