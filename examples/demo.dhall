let Zuul = env:DHALL_ZUUL ? ../package.dhall

let nodeset-name = "my-nodeset"

in    Zuul.Nodeset.wrap
        [ Zuul.Nodeset::{
          , name = Some nodeset-name
          , nodes = [ { name = "container", label = "my-label" } ]
          }
        ]
    # Zuul.Job.wrap
        [ Zuul.Job::{
          , name = Some "test"
          , nodeset = Some (Zuul.Nodeset.Name nodeset-name)
          }
        , Zuul.Job::{
          , name = Some "test-with-inlined-nodeset"
          , nodeset = Zuul.Nodeset.mkSimpleInline "another-label"
          }
        , Zuul.Job::{ name = Some "publish" }
        ]