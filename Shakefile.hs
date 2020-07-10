#!/usr/bin/env stack
-- stack script --resolver lts-15.3 --package shake --package dhall --package text
--
-- Copyright (C) 2020 Red Hat
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may
-- not use this file except in compliance with the License. You may obtain
-- a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
-- License for the specific language governing permissions and limitations
-- under the License.
--
--
-- Install stack using:
-- sudo dnf copr enable -y petersen/stack2 && sudo dnf install -y stack && sudo stack upgrade
-- Then Execute this file to update the binding
--

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

import Control.Monad (unless)
import Data.Char
import Data.List (sortOn, takeWhile)
import Data.Text (Text, pack, unpack)
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util
-- import qualified Dhall.Core (Expr (..), denote)
import Dhall.Core
import Dhall.Map (fromList, toList)
import Dhall.Parser (exprFromText)
import Dhall.Pretty (prettyExpr)

-- | Convert a dhall type record to a value record using None value for Optional attributes
-- | >>> getDefaults "./types/test.dhall" "{ name : Text, become : Optional Bool, task : Optional ./Task.dhall }"
-- | "{ become = None Bool, task = None ../types/Task.dhall }"
getDefaults :: FilePath -> Text -> Text
getDefaults fn content = decode
  where
    decode :: Text
    decode = case exprFromText fn content of
      Left err -> error $ show err
      Right expr -> case Dhall.Core.denote expr of
        Record record -> pack $ (show $ prettyExpr $ process record) <> "\n"
        _ -> error $ fn <> ": is not a record type"
    process record = RecordLit $ fromList $ sortOn fst $ go $ toList record
    -- Process every record element
    go :: [(Text, Expr s Import)] -> [(Text, Expr s Import)]
    go [] = []
    go ((n, App Optional v) : xs) = (n, App None v) : go xs
    go (x : xs) = go xs

isRecord :: FilePath -> Text -> Bool
isRecord fn content = case exprFromText fn content of
  Left _ -> False
  Right expr -> case Dhall.Core.denote expr of
    Record _ -> True
    _ -> False

main :: IO ()
main = shakeArgs shakeOptions {shakeFiles = "_build"} $ do
  want ["package.dhall"]

  --  TODO: generate package
  --  "package.dhall" %> \out -> do
  phony "package.dhall" $ do
    files <- getDirectoryFiles "" ["//Type.dhall"]
    filesContent <- mapM readFile' files
    let defaultable = map fst $ filter (\(fn, content) -> isRecord fn (pack content)) $ zip files filesContent
    need (Prelude.map (ren "default.dhall") defaultable)
--    need (Prelude.map (ren "wrapped.dhall") files)

  "//default.dhall" %> \dst -> do
    let src = ren "Type.dhall" dst
    putInfo $ dst <> ": created from " <> src
    fileContent <- readFile' src
    writeFile' dst $ unpack (getDefaults src $ pack fileContent)

  "//wrapped.dhall" %> \dst -> do
    let nam = objName dst
    putInfo $ dst <> ": created using " <> nam
    -- TODO: use proper dhall expression
    writeFile' dst ("{ " <> nam <> " : ./Type.dhall }\n")
  where
    ren fn2 fn = joinPath (dropLast fns <> [fn2])
      where fns = splitPath fn
    dropLast = reverse . drop 1 . reverse
    sub dir fn = joinPath ([dir] <> Prelude.drop 1 (splitPath fn))
    objName fn = dropLast $ takeWhile (/= '.') $ go $ head $ drop 1 $ reverse $ splitPath fn
      where go (x:xs) = Data.Char.toLower x : xs
