let Zuul = env:DHALL_ZUUL ? ../package.dhall

let nodeset-name = "my-nodeset"

in    Zuul.Nodeset.pack
        [ Zuul.Nodeset::{
          , name = Some nodeset-name
          , nodes = [ { name = "container", label = "my-label" } ]
          }
        ]
    # Zuul.Job.pack
        [ Zuul.Job::{
          , name = Some "test"
          , nodeset = Some (Zuul.NodesetOrString.String nodeset-name)
          }
        , Zuul.Job::{ name = Some "publish" }
        ]
