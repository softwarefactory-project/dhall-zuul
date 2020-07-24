{- A convenient function to transform a text bool into a JSON.object -}
let Map = (../../imports/Prelude.dhall).Map

let mapBool
    : Map.Type Text Bool -> ./Type.dhall
    = ./map.dhall Bool ./bool.dhall

let example0 =
        assert
      :     mapBool (toMap { testKey = True })
        ===  ./object.dhall
               [ { mapKey = "testKey", mapValue = ./bool.dhall True } ]

in  mapBool
