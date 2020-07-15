# dhall-zuul

`dhall-zuul` contains [Dhall][dhall-lang] bindings to [Zuul][zuul],
so you can generate zuul configuration from Dhall expressions.

## Example

Using the `wrap` function, different objects can be combined in a single list:

```dhall
-- ./examples/demo.dhall
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
    name: test-with-inlined-nodeset
    nodeset:
      nodes:
        - label: another-label
          name: another-label
- job:
    name: publish

```

## Generate job

```dhall
-- ./examples/generate-jobs.dhall
let Zuul = env:DHALL_ZUUL ? ../package.dhall

let Job = Zuul.Job::{ name = Some "bench-job" }

let Jobs =
      Zuul.Job.mapJob
        (Zuul.Job.setParent "bench-job")
        (Zuul.Job.replicate 3 Job)

in    Zuul.Job.wrap ([ Job ] # Jobs)
    # Zuul.Project.wrap
        [ toMap
            { check =
                Zuul.Project.mkSimplePipeline
                  (Zuul.Job.map Text Zuul.Job.getName Jobs)
            }
        ]

```

```yaml
- job:
    name: bench-job
- job:
    name: bench-job-1
    parent: bench-job
- job:
    name: bench-job-2
    parent: bench-job
- job:
    name: bench-job-3
    parent: bench-job
- project:
    check:
      jobs:
        - bench-job-1
        - bench-job-2
        - bench-job-3

```

## Project map

The `project` object admits arbitary attribute for pipeline name, and it is
defined as a Map that can be used like so:

```dhall
-- ./examples/final.dhall
let Zuul = env:DHALL_ZUUL ? ../package.dhall

let project =
      toMap
        { name = Zuul.Project.Name "dhall-zuul"
        , check =
            Zuul.Project.Pipeline
              (Zuul.ProjectPipeline.mkSimple [ "test", "publish" ])
        }

in    Zuul.Job.wrap
        [ Zuul.Job::{ name = Some "test" }
        , Zuul.Job::{ name = Some "publish" }
        ]
    # Zuul.Project.wrap [ project ]

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
