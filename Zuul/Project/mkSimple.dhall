\(job-names : List Text) ->
      ../ProjectPipeline/default.dhall
  //  { jobs =
          ../../imports/map.dhall
            Text
            ../Job/union.dhall
            ../Job/Name.dhall
            job-names
      }
