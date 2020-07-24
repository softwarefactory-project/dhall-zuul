{ abstract = None Bool
, ansible-version = None Text
, attempts = None Natural
, description = None Text
, host-vars = None ../Vars/Type.dhall
, name = None Text
, nodeset = None ../Nodeset/union.dhall
, parent = None Text
, post-run = None (List Text)
, pre-run = None (List Text)
, required-projects = None (List { name : Text })
, run = None Text
, vars = None ../Vars/Type.dhall
}
