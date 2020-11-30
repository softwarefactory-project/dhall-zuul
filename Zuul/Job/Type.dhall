{ name : Optional Text
, parent : Optional Text
, abstract : Optional Bool
, ansible-version : Optional Text
, branches : Optional (List Text)
, description : Optional Text
, pre-run : Optional (List Text)
, run : Optional Text
, post-run : Optional (List Text)
, attempts : Optional Natural
, dependencies : Optional (List ./Dependency/union.dhall)
, nodeset : Optional ../Nodeset/union.dhall
, override-checkout : Optional Text
, vars : Optional ../Vars/Type.dhall
, host-vars : Optional ../Vars/Type.dhall
, secrets : Optional (List ./Secret/Type.dhall)
, roles : Optional (List { zuul : Text })
, required-projects : Optional (List { name : Text })
}
