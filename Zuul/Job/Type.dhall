{ name : Optional Text
, parent : Optional Text
, abstract : Optional Bool
, ansible-version : Optional Text
, description : Optional Text
, pre-run : Optional (List Text)
, run : Optional Text
, post-run : Optional (List Text)
, attempts : Optional Natural
, nodeset : Optional ../Nodeset/union.dhall
, host-vars : Optional (../../imports/Prelude.dhall).JSON.Type
, vars : Optional (List { mapKey : Text, mapValue : Text })
, required-projects : Optional (List { name : Text })
}
