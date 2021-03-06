{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module Network.Hydra.Eval
  ( Input (..),
    EvalInputs,
    Eval (..),
    Evals (..),
  )
where

--------------------------------------------------------------------------------

import Data.Aeson
import Data.Aeson.Types (Parser)
import qualified Data.HashMap.Strict as HM
import qualified Data.List as L
import Data.Map.Strict as M
import Data.Text
import Network.Hydra.Internal.Utils

--------------------------------------------------------------------------------

data Input = Input
  { inputType :: Text, -- Valid values are limited "build, boolean, git, etc..."
    value :: Maybe Text,
    uri :: Maybe Text,
    revision :: Maybe Text,
    dependency :: Maybe Int -- build ID of the input, for type == 'build'
  }
  deriving (Show)

type EvalInputs = M.Map Text Input

data Eval = Eval
  { id :: Int,
    jobsetEvalInputs :: EvalInputs,
    hasNewBuilds :: Bool,
    builds :: [Int]
  }
  deriving (Show)

instance FromJSON Eval where
  parseJSON = withObject "Eval" $ \o ->
    Eval <$> o .: "id"
      <*> ((o .: "jobsetevalinputs") >>= parseInputs)
      <*> (_int2Bool <$> (o .: "hasnewbuilds"))
      <*> o .: "builds"

parseInputs :: HM.HashMap Text Value -> Parser EvalInputs
parseInputs m =
  M.fromList <$> (mapM parseInput . HM.toList $ m)

parseInput :: (Text, Value) -> Parser (Text, Input)
parseInput (t, v) =
  withObject
    "Input"
    ( \o ->
        (t,)
          <$> ( Input <$> o .: "type"
                  <*> o .:? "value"
                  <*> o .:? "uri"
                  <*> o .:? "revision"
                  <*> o .:? "dependency"
              )
    )
    v

newtype Evals = Evals {evals :: [Eval]} deriving (Show)

instance FromJSON Evals where
  parseJSON = withObject "Evals" (\o -> Evals <$> (o .: "evals"))
