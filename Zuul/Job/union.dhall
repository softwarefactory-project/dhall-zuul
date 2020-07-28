{-|
The two ways to reference a Job
-}
let Job = ./schema.dhall

let Map = (../../imports/Prelude.dhall).Map.Type

in  < Name : Text | Inline : Map Text Job.Type >
