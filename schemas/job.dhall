{ Type = ../types/job.dhall
, default = ../defaults/job.dhall
, Box = ../boxed-types/job.dhall
, pack =
    ../functions/map.dhall
      ../types/job.dhall
      ../typesUnion.dhall
      (\(job : ../types/job.dhall) -> (../typesUnion.dhall).Job { job })
}
