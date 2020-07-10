{- TODO: improve the implementation -}
let Prelude =
        env:DHALL_PRELUDE
      ? https://prelude.dhall-lang.org/v17.0.0/package.dhall sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e

in  \(count : Natural) ->
      let seq = Prelude.List.replicate count Natural 1

      let indexed = Prelude.List.indexed Natural seq

      let IndexedType = { index : Natural, value : Natural }

      in  Prelude.List.map
            IndexedType
            Natural
            (\(index : IndexedType) -> index.index + 1)
            indexed
