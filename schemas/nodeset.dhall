{ Type = ../types/nodeset.dhall
, default = ../defaults/nodeset.dhall
, Box = ../boxed-types/nodeset.dhall
, pack =
    ../functions/map.dhall
      ../types/nodeset.dhall
      ../typesUnion.dhall
      ( \(nodeset : ../types/nodeset.dhall) ->
          (../typesUnion.dhall).Nodeset { nodeset }
      )
}
