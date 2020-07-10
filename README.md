# dhall-zuul

`dhall-zuul` contains [Dhall][dhall-lang] bindings to [Zuul][zuul],
so you can generate zuul configuration from Dhall expressions.

## Example

Using the `pack` function, different objects can be combined in a single list:

```dhall
-- ./examples/demo.dhall
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

```

```yaml
- nodeset:
    name: my-nodeset
    nodes:
      - label: my-label
        name: container
- job:
    name: test
    nodeset: my-nodeset
- job:
    name: publish

```


## Caveats

The `project` object admits arbitary value for pipeline name, and it is
defined as a Map that can be used like so:

```dhall
-- ./examples/final.dhall
let Zuul = env:DHALL_ZUUL ? ../package.dhall

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , check = Zuul.jobNamesToPipeline [ "test", "publish" ]
        }

in    Zuul.Job.pack
        [ Zuul.Job::{ name = Some "test" }
        , Zuul.Job::{ name = Some "publish" }
        ]
    # Zuul.Project.pack [ project ]

```

```yaml
- job:
    name: test
- job:
    name: publish
- project:
    check:
      jobs:
        - test
        - publish
    name: dhall-zuul

```
