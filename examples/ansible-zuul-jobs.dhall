let JSON =
      https://prelude.dhall-lang.org/JSON/package.dhall sha256:79dfc281a05bc7b78f927e0da0c274ee5709b1c55c9e5f59499cb28e9d6f3ec0

let Zuul = env:DHALL_ZUUL ? ../package.dhall

let empty-nodeset = Zuul.Nodeset.Inline Zuul.Nodeset.empty

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
        , nodeset = Some empty-nodeset
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

let N =
      { centos8 = "centos-8-1vcpu"
      , centos7 = "centos-7-1vcpu"
      , fedora = "fedora-latest-1vcpu"
      , xenial = "ubuntu-xenial-1vcpu"
      , bionic = "ubuntu-bionic-1vcpu"
      }

let toxs =
      [ mkVariant N.centos8 "tox-docs"
      , mkVariant N.centos8 "tox-linters"
      , mkVariant N.centos8 "tox-docs"
      , mkVariant N.centos7 "tox-py27"
      , mkVariant N.xenial "tox-py35"
      , mkVariant N.centos8 "tox-py36"
      , mkVariant N.centos8 "tox-py37"
      , mkVariant N.bionic "tox-py38"
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
      \(host-var : Text) ->
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
                    [ { mapKey = host-var, mapValue = JSON.object host-vars } ]
                )
            , nodeset = Some (Zuul.Nodeset.Name "${host-var}-${nodeset-suffix}")
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
