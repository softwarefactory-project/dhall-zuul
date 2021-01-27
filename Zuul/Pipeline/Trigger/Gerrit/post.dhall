--| The typical post trigger for gerrit
let Gerrit =
      { Type = ./Type.dhall, default = ./default.dhall, Event = ./Event.dhall }

in  ../gerrit.dhall
      [ Gerrit::{
        , event = [ Gerrit.Event.ref-updated ]
        , ref = Some [ "^refs/heads/.*\$" ]
        }
      ]
