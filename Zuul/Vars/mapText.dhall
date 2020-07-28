{-|
A convenient function to transform a text map into a JSON.object
-}
let Map = (../../imports/Prelude.dhall).Map

let mapText
    : Map.Type Text Text -> ./Type.dhall
    = ./map.dhall Text ./string.dhall

let example0 =
        assert
      :     mapText (toMap { testKey = "value" })
        ===  ./object.dhall
               [ { mapKey = "testKey", mapValue = ./string.dhall "value" } ]

in  mapText
