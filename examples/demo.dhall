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
          , name = Some "test"
          , nodeset = Some (Zuul.Nodeset.Name nodeset-name)
          , vars = Some (Zuul.Vars.mapBool (toMap { debug = True }))
          }
        , Zuul.Job::{
          , name = Some "test-with-inlined-nodeset"
          , nodeset = Zuul.Nodeset.mkSimpleInline nodeset-name "another-label"
          }
        , Zuul.Job::{ name = Some "publish" }
        ]
