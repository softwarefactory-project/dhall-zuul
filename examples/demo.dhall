let Zuul = ../package.dhall

let nodeset-name = "my-nodeset"

in    Zuul.Nodeset.wrap
        [ Zuul.Nodeset::{
          , name = nodeset-name
          , nodes = [ { name = "container", label = "my-label" } ]
          }
        ]
    # Zuul.Job.wrap
        [ Zuul.Job::{
          , name = "test"
          , nodeset = Some (Zuul.Nodeset.Name nodeset-name)
          , vars = Some (Zuul.Vars.mapBool (toMap { debug = True }))
          }
        , Zuul.Job::{
          , name = "test-with-inlined-nodeset"
          , nodeset = Zuul.Nodeset.mkSimpleInline "another-label"
          }
        , Zuul.Job::{ name = "publish" }
        ]
