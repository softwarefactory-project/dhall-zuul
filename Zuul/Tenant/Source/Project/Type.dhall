{ load-branch : Optional Text
, include : Optional (List ./ConfigurationItems.dhall)
, exclude : Optional (List ./ConfigurationItems.dhall)
, shadow : Optional (List Text)
, exclude-unprotected-branches : Optional Bool
, extra-config-paths : Optional (List Text)
}
