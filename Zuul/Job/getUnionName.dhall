let Job = { Union = ./Union.dhall }

let Prelude = ../../imports/Prelude.dhall

let getUnionName
    : Job.Union -> Text
    = \(job : Job.Union) ->
        merge
          { Name = \(name : Text) -> name
          , Inline =
              \(map : Prelude.Map.Type Text ./InlineType.dhall) ->
                merge
                  { None = "", Some = \(name : Text) -> name }
                  ( Prelude.List.head
                      Text
                      (Prelude.Map.keys Text ./InlineType.dhall map)
                  )
          }
          job

in  getUnionName
