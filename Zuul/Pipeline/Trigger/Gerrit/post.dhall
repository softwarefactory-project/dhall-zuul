--| The typical post trigger for gerrit
let Gerrit = { Type = ./Type.dhall, default = ./default.dhall }

in  ../gerrit.dhall
      [ Gerrit::{ event = "ref-updated", ref = Some "^refs/heads/.*\$" } ]
