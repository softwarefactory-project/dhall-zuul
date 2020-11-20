{ abstract = None Bool
, ansible-version = None Text
, attempts = None Natural
, dependencies = None (List ./Dependency/union.dhall)
, description = None Text
, host-vars = None ../Vars/Type.dhall
, name = None Text
, nodeset = None ../Nodeset/union.dhall
, parent = None Text
, post-run = None (List Text)
, pre-run = None (List Text)
, required-projects = None (List { name : Text })
, roles = None (List { zuul : Text })
, run = None Text
, secrets = None (List ./Secret/Type.dhall)
, vars = None ../Vars/Type.dhall
}
