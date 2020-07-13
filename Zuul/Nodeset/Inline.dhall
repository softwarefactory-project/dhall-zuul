{- Construct a Nodeset.Union using an inlined Nodeset.

   For example, to add a nodeset to a job configuration:

   ```
   Zuul.Job::{
     nodeset = Some (Zuul.Nodeset.Inline Zuul.Nodeset.mkSimple "test-label")
   }
   ```
-}
let Nodeset = { Type = ./Type.dhall, Union = ./union.dhall }

let Inline
    : Nodeset.Type -> Nodeset.Union
    = (./union.dhall).Inline

in  Inline
