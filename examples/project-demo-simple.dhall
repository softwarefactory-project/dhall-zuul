{- No need for using the Zuul.Project for standalone file -}

let Zuul = env:DHALL_ZUUL ? ../package.dhall

in  { project =
      { name = "dhall-zuul"
      , check = Zuul.ProjectPipeline::{ jobs = [ "dhall-lint" ] }
      }
    }
