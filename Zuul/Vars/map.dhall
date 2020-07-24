{- A convenient function to transform a dhall map into a JSON.object -}
let Map = (../../imports/Prelude.dhall).Map

let map
    : forall (valueType : Type) ->
      forall (transformer : valueType -> ./Type.dhall) ->
      forall (map : Map.Type Text valueType) ->
        ./Type.dhall
    = \(valueType : Type) ->
      \(transformer : valueType -> ./Type.dhall) ->
      \(map : Map.Type Text valueType) ->
        ./object.dhall (Map.map Text valueType ./Type.dhall transformer map)

let example0 =
        assert
      :     map Bool ./bool.dhall (toMap { testKey = True })
        ===  ./object.dhall
               [ { mapKey = "testKey", mapValue = ./bool.dhall True } ]

in  map
