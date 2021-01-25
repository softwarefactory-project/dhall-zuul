-- Interpret using this command:
--    podman run -it --rm -v $(pwd):/data:Z quay.io/software-factory/shake-factory
--
-- Learn more at: https://softwarefactory-project.io/cgit/software-factory/shake-factory/tree/README.md

import Data.Char (toLower)
import Development.Shake
import Development.Shake.FilePath
import ShakeFactory
import ShakeFactory.Dhall
import Text.Casing (kebab)

getName :: FilePath -> String
getName fp = reverse $ drop 1 $ reverse $ head $ drop 1 $ splitPath fp

createContent :: String -> [String] -> String
createContent comment content = unlines $ ["{-|", comment, "-}", ""] <> content

createWrapped :: FilePath -> Action ()
createWrapped fp = writeFile' fp content
  where
    name = getName fp
    content =
      createContent
        ("A wrapped version of the Zuul." <> name <> ".Type")
        ["{ " <> kebab name <> " : ./Type.dhall }"]

createWrap :: FilePath -> Action ()
createWrap fp = writeFile' fp content
  where
    name = getName fp
    content =
      createContent
        ("A function to wrap a list of Zuul." <> name <> ".Type")
        [ "let " <> name <> " = { Type = ./Type.dhall }",
          "",
          "let typesUnion = ../Resource.dhall",
          "",
          "let wrap",
          "    : List " <> name <> ".Type -> List typesUnion",
          "    = ../../imports/map.dhall",
          "        " <> name <> ".Type",
          "        typesUnion",
          "        (\\(" <> kebab name <> " : " <> name <> ".Type) -> typesUnion." <> name <> " { " <> kebab name <> " })",
          "",
          "in  wrap"
        ]

createWant :: FilePath -> [FilePath]
createWant fn = map (\obj -> "Zuul/" <> obj <> "/" <> fn) confObjects
  where
    confObjects = ["Job", "Nodeset", "Project", "Tenant", "Secret", "Semaphore", "Pipeline", "ProjectTemplate"]

main = shakeMain $ do
  want $ ["README.md", "package.dhall", ".zuul.yaml"] <> createWant "wrapped.dhall" <> createWant "wrap.dhall"
  "README.md" %> dhallReadmeAction
  "package.dhall" %> dhallTopLevelPackageAction "./Zuul/package.dhall"
  "//wrapped.dhall" %> createWrapped
  "//wrap.dhall" %> createWrap
  "//package.dhall" %> dhallPackageAction
  "//default.dhall" %> dhallDefaultAction
  "Zuul/Resource.dhall" %> dhallUnionAction ["*/wrapped.dhall"]
  ".zuul.yaml" %> dhallYaml "./examples/dhall-zuul-ci.dhall"
  dhallDocsRules "dhall-zuul"
  dhallReleaseRules "./Zuul/package.dhall"
  cleanRules
