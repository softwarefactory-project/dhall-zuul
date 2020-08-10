{ max-nodes-per-job = None Natural
, max-job-timeout = None Natural
, exclude-unprotected-branches = None Bool
, default-parent = None Text
, default-ansible-version = None Text
, allowed-triggers = None (List Text)
, allowed-reporters = None (List Text)
, allowed-labels = None (List Text)
, disallowed-labels = None (List Text)
, report-build-page = None Bool
, web-root = None Text
, admin-rules = None (List Text)
, source = [] : List { mapKey : Text, mapValue : Text }
}
