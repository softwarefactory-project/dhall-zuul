{-|
A function to wrap a list of Zuul.Tenant.Type
-}

let Tenant = { Type = ./Type.dhall }

let typesUnion = ../Resource.dhall

let wrap
    : List Tenant.Type -> List typesUnion
    = ../../imports/map.dhall
        Tenant.Type
        typesUnion
        (\(tenant : Tenant.Type) -> typesUnion.Tenant { tenant })

in  wrap
