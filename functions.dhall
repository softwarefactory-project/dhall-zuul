let map = ./functions/map.dhall

let seq = ./functions/seq.dhall

let jobList =
      map
        Text
        ./unions/job-or-string.dhall
        (./unions/job-or-string.dhall).String

let jobNamesToPipeline =
      \(job-names : List Text) ->
        (./unions/pipeline-or-name.dhall).Pipeline
          (./schemas/project-pipeline.dhall)::{ jobs = jobList job-names }

let labelToNodeset =
      \(label : Text) ->
        (./unions/nodeset-or-string.dhall).Nodeset
          (./schemas/nodeset.dhall)::{ nodes = [ { name = label, label } ] }

in  { map, seq, jobList, jobNamesToPipeline, labelToNodeset }
