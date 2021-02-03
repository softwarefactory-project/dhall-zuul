{ name : Text
, source : List ./Source/map.dhall
, max-nodes-per-job : Optional Natural
, max-job-timeout : Optional Natural
, exclude-unprotected-branches : Optional Bool
, default-parent : Optional Text
, default-ansible-version : Optional Text
, allowed-triggers : Optional (List Text)
, allowed-reporters : Optional (List Text)
, allowed-labels : Optional (List Text)
, disallowed-labels : Optional (List Text)
, report-build-page : Optional Bool
, web-root : Optional Text
, admin-rules : Optional (List Text)
}
