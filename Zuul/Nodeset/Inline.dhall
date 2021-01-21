{-|
Construct a Nodeset.Union using an inlined Nodeset.

   For example, to add a nodeset to a job configuration:

   ```
   Zuul.Job::{
     nodeset = Some (Zuul.Nodeset.Inline Zuul.Nodeset.mkSimple "test-label")
   }
   ```
-}
let Nodeset = { InlineType = ./InlineType.dhall, Union = ./union.dhall }

let Inline
    : Nodeset.InlineType → Nodeset.Union
    = (./union.dhall).Inline

in  Inline
