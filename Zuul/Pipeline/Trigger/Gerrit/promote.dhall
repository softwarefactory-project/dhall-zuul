--| The typical promote trigger for gerrit
let Gerrit = { Type = ./Type.dhall, default = ./default.dhall }

in  ../gerrit.dhall [ Gerrit::{ event = "change-merged", ref = None Text } ]
