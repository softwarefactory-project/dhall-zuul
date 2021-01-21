let Prelude = ../../imports/Prelude.dhall

let getUnionName
    : ./union.dhall -> Text
    = \(job : ./union.dhall) ->
        merge
          { Name = \(name : Text) -> name
          , Inline =
              \(map : Prelude.Map.Type Text ./Type.dhall) ->
                merge
                  { None = "", Some = \(name : Text) -> name }
                  ( Prelude.List.head
                      Text
                      (Prelude.Map.keys Text ./Type.dhall map)
                  )
          }
          job

in  getUnionName