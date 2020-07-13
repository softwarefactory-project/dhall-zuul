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
-- | >>> getDefaults "./Job/Type.dhall" "{ name : Text, become : Optional Bool, task : Optional ./Task.dhall }"
-- | "{ become = None Bool, task = None ./Task.dhall }"
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

  "//default.dhall" %> \dst -> do
    let src = ren "Type.dhall" dst
    putInfo $ dst <> ": created from " <> src
    fileContent <- readFile' src
    writeFile' dst $ unpack (getDefaults src $ pack fileContent)

  where
    sub dir fn = joinPath ([dir] <> Prelude.drop 1 (splitPath fn))
    ren fn2 fn = joinPath (dropLast (splitPath fn) <> [fn2])
    dropLast = reverse . drop 1 . reverse
