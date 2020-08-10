let Zuul = ../package.dhall

let tenant =
      Zuul.Tenant::{
      , name = "ansible"
      , max-nodes-per-job = Some 42
      , source = toMap
          { gerrit = Zuul.Connection::{
            , config-projects = Some
              [ Zuul.SourceProject.Name "common-config"
              , Zuul.SourceProject.WithOptions
                  Zuul.SourceProject::{
                  , include = Some [ Zuul.ConfigurationItems.job ]
                  }
                  "shared-jobs"
              ]
            , untrusted-projects = Some
              [ Zuul.SourceProject.WithOptions
                  Zuul.SourceProject::{ shadow = Some [ "comon-config" ] }
                  "zuul/zuul-jobs"
              , Zuul.SourceProject.Name "project1"
              , Zuul.SourceProject.WithOptions
                  Zuul.SourceProject::{
                  , exclude-unprotected-branches = Some True
                  }
                  "project2"
              ]
            }
          }
      }

in  Zuul.Tenant.wrap [ tenant ]
