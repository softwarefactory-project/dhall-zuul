let Zuul = ../package.dhall

let Project = Zuul.Tenant.Source.Project

let tenant =
      Zuul.Tenant::{
      , name = "ansible"
      , max-nodes-per-job = Some 42
      , source = toMap
          { gerrit = Zuul.Tenant.Source::{
            , config-projects = Some
              [ Project.Name "common-config"
              , Project.WithOptions
                  Project::{ include = Some [ Project.ConfigurationItems.job ] }
                  "shared-jobs"
              ]
            , untrusted-projects = Some
              [ Project.WithOptions
                  Project::{ shadow = Some [ "comon-config" ] }
                  "zuul/zuul-jobs"
              , Project.Name "project1"
              , Project.WithOptions
                  Project::{ exclude-unprotected-branches = Some True }
                  "project2"
              ]
            }
          }
      }

in  Zuul.Tenant.wrap [ tenant ]
