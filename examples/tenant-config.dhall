let Zuul = ../package.dhall

let tenant = Zuul.Tenant::{ name = "ansible", max-nodes-per-job = Some 42 }

in  Zuul.Tenant.wrap [ tenant ]
