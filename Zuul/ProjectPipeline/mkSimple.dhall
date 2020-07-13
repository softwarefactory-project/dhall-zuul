\(job-names : List Text) ->
      ./default.dhall
  //  { jobs =
          ../../imports/map.dhall
            Text
            ../Job/union.dhall
            ../Job/Name.dhall
            job-names
      }
