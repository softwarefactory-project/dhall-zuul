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
let Zuul =
        https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall sha256:6ba224314853608af08a4c2886f7b97f8e7c80b1c48c2f9f5b32ea6446f3bb15
      ? https://softwarefactory-project.io/cgit/software-factory/dhall-zuul/plain/package.dhall

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

## Complex job example

Function can be used to generate complex job:

```dhall
-- ./examples/ansible-zuul-jobs.dhall
{- https://github.com/ansible/ansible-zuul-jobs/blob/master/zuul.d/jobs.yaml
   contains a lot of duplication and updates are error prone.

   Here is how to use a couple of functions `mkVariant` and `mkNetwork` to
   maintain the jobs definitions.
-}
let JSON =
      https://prelude.dhall-lang.org/JSON/package.dhall sha256:79dfc281a05bc7b78f927e0da0c274ee5709b1c55c9e5f59499cb28e9d6f3ec0

let Zuul = env:DHALL_ZUUL ? ../package.dhall

let base =
      [ Zuul.Job::{
        , name = Some "base"
        , parent = Some "base-minimal"
        , abstract = Some True
        , ansible-version = Some "2.9"
        , description = Some
            "The base job for the Ansible installation of Zuul."
        , pre-run = Some [ "playbooks/base/pre.yaml" ]
        }
      , Zuul.Job::{
        , name = Some "github-workflows"
        , description = Some
            "A job to validate no github workflow directory are found."
        , run = Some "playbooks/github-workflows/run.yaml"
        , nodeset = Some (Zuul.Nodeset.Inline Zuul.Nodeset.empty)
        }
      ]

let {- A function to create simple zuul-jobs variant with `ansible-` prefix
    -} mkVariant =
      \(nodeset : Text) ->
      \(parent-name : Text) ->
        Zuul.Job::{
        , name = Some "ansible-${parent-name}"
        , parent = Some parent-name
        , nodeset = Some (Zuul.Nodeset.Name nodeset)
        }

let Nodeset =
      { centos8 = "centos-8-1vcpu"
      , centos7 = "centos-7-1vcpu"
      , fedora = "fedora-latest-1vcpu"
      , xenial = "ubuntu-xenial-1vcpu"
      , bionic = "ubuntu-bionic-1vcpu"
      }

let toxs =
      [ mkVariant Nodeset.centos8 "tox-docs"
      , mkVariant Nodeset.centos8 "tox-linters"
      , mkVariant Nodeset.centos8 "tox-docs"
      , mkVariant Nodeset.centos7 "tox-py27"
      , mkVariant Nodeset.xenial "tox-py35"
      , mkVariant Nodeset.centos8 "tox-py36"
      , mkVariant Nodeset.centos8 "tox-py37"
      , mkVariant Nodeset.bionic "tox-py38"
      ]

let network-base =
      Zuul.Job::{
      , name = Some "ansible-network-appliance-base"
      , pre-run = Some [ "playbooks/ansible-network-appliance-base/pre.yaml" ]
      , post-run = Some [ "playbooks/ansible-network-appliance-base/post.yaml" ]
      }

let {- A function to create a network job
    -} mkNetwork =
      \(name : Text) ->
      \(host-var-name : Text) ->
      \(nodeset-suffix : Text) ->
        let host-vars =
              toMap
                { ansible_connection = JSON.string "network_cli"
                , ansible_network_os = JSON.string "asa"
                , ansible_python_interpreter = JSON.string "python"
                }

        in  Zuul.Job::{
            , name = Some "ansible-network-${name}-appliance"
            , parent = Some (Zuul.Job.getName network-base)
            , pre-run = Some
              [ "playbooks/ansible/network-${name}-appliance/pre.yaml" ]
            , run = Some "playbooks/ansible/network-${name}-appliance/run.yaml"
            , host-vars = Some
                ( JSON.object
                    [ { mapKey = host-var-name
                      , mapValue = JSON.object host-vars
                      }
                    ]
                )
            , nodeset = Some
                (Zuul.Nodeset.Name "${host-var-name}-${nodeset-suffix}")
            , required-projects = Some
              [ { name = "github.com/ansible/ansible-zuul-jobs" } ]
            }

let networks =
      [ network-base
      , mkNetwork "asa" "asav9-12-3" "python36"
      , mkNetwork "eos" "eos-4.20.10" "python36"
      , mkNetwork "ios" "ios-15.6-2T" "python36"
      , mkNetwork "iosxr" "iosxr-6.1.3" "python36"
      , mkNetwork "vsrx" "vsrx3-18.4R1" "python36"
      , mkNetwork "vqfx" "vqfx-18.1R3" "python36"
      , mkNetwork "nxos" "nxos-7.0.3" "python36"
      , mkNetwork "openvswitch" "openvswitch-2.9.0" "python36"
      ]

in  Zuul.Job.wrap (base # toxs # networks)

```

```yaml
- job:
    abstract: true
    ansible-version: '2.9'
    description: The base job for the Ansible installation of Zuul.
    name: base
    parent: base-minimal
    pre-run:
      - playbooks/base/pre.yaml
- job:
    description: A job to validate no github workflow directory are found.
    name: github-workflows
    nodeset:
      nodes: []
    run: playbooks/github-workflows/run.yaml
- job:
    name: ansible-tox-docs
    nodeset: centos-8-1vcpu
    parent: tox-docs
- job:
    name: ansible-tox-linters
    nodeset: centos-8-1vcpu
    parent: tox-linters
- job:
    name: ansible-tox-docs
    nodeset: centos-8-1vcpu
    parent: tox-docs
- job:
    name: ansible-tox-py27
    nodeset: centos-7-1vcpu
    parent: tox-py27
- job:
    name: ansible-tox-py35
    nodeset: ubuntu-xenial-1vcpu
    parent: tox-py35
- job:
    name: ansible-tox-py36
    nodeset: centos-8-1vcpu
    parent: tox-py36
- job:
    name: ansible-tox-py37
    nodeset: centos-8-1vcpu
    parent: tox-py37
- job:
    name: ansible-tox-py38
    nodeset: ubuntu-bionic-1vcpu
    parent: tox-py38
- job:
    name: ansible-network-appliance-base
    post-run:
      - playbooks/ansible-network-appliance-base/post.yaml
    pre-run:
      - playbooks/ansible-network-appliance-base/pre.yaml
- job:
    host-vars:
      asav9-12-3:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-asa-appliance
    nodeset: asav9-12-3-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-asa-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-asa-appliance/run.yaml
- job:
    host-vars:
      eos-4.20.10:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-eos-appliance
    nodeset: eos-4.20.10-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-eos-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-eos-appliance/run.yaml
- job:
    host-vars:
      ios-15.6-2T:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-ios-appliance
    nodeset: ios-15.6-2T-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-ios-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-ios-appliance/run.yaml
- job:
    host-vars:
      iosxr-6.1.3:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-iosxr-appliance
    nodeset: iosxr-6.1.3-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-iosxr-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-iosxr-appliance/run.yaml
- job:
    host-vars:
      vsrx3-18.4R1:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-vsrx-appliance
    nodeset: vsrx3-18.4R1-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-vsrx-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-vsrx-appliance/run.yaml
- job:
    host-vars:
      vqfx-18.1R3:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-vqfx-appliance
    nodeset: vqfx-18.1R3-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-vqfx-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-vqfx-appliance/run.yaml
- job:
    host-vars:
      nxos-7.0.3:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-nxos-appliance
    nodeset: nxos-7.0.3-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-nxos-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-nxos-appliance/run.yaml
- job:
    host-vars:
      openvswitch-2.9.0:
        ansible_connection: network_cli
        ansible_network_os: asa
        ansible_python_interpreter: python
    name: ansible-network-openvswitch-appliance
    nodeset: openvswitch-2.9.0-python36
    parent: ansible-network-appliance-base
    pre-run:
      - playbooks/ansible/network-openvswitch-appliance/pre.yaml
    required-projects:
      - name: github.com/ansible/ansible-zuul-jobs
    run: playbooks/ansible/network-openvswitch-appliance/run.yaml

```
