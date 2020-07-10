{- Create a nodeset with a single node named after the label -}
\(label-name : Text) ->
  ./default.dhall // { nodes = [ { name = label-name, label = label-name } ] }
