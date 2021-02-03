{-|
The two ways to reference a Job
-}
let Map = (../../../../imports/Prelude.dhall).Map.Type

in  < Name : Text | Inline : Map Text ./Type.dhall >
