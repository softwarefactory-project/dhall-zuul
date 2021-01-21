{ parent : Optional Text
, description : Optional Text
, final : Optional Bool
, protected : Optional Bool
, abstract : Optional Bool
, intermediate : Optional Bool
, success-message : Optional Text
, failure-message : Optional Text
, success-url : Optional Text
, failure-url : Optional Text
, hold-following-changes : Optional Bool
, voting : Optional Bool
, semaphore : Optional ./Semaphore/Type.dhall
, tags : Optional (List Text)
, provides : Optional (List Text)
, requires : Optional (List Text)
, secrets : Optional (List ./Secret/Type.dhall)
, nodeset : Optional ../Nodeset/Union.dhall
, override-checkout : Optional Text
, timeout : Optional Natural
, post-timeout : Optional Natural
, attempts : Optional Natural
, pre-run : Optional (List Text)
, post-run : Optional (List Text)
, cleanup-run : Optional (List Text)
, run : Optional Text
, ansible-version : Optional Text
, roles : Optional (List { zuul : Text })
, required-projects : Optional (List ./RequiredProject/Type.dhall)
, vars : Optional ../Vars/Type.dhall
, extra-vars : Optional ../Vars/Type.dhall
, host-vars : Optional ../Vars/Type.dhall
, group-vars : Optional ../Vars/Type.dhall
, dependencies : Optional (List ./Dependency/Union.dhall)
, allowed-projects : Optional (List Text)
, post-review : Optional Bool
, branches : Optional (List Text)
, files : Optional (List Text)
, irrelevant-files : Optional (List Text)
, match-on-config-updates : Optional Bool
}
