{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module Network.Hydra.Measures
  ( BuildTimes (..),
    OutputSizes (..),
    ClosureSizes (..),
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

data Measure = Measure
  { buildId :: Maybe Int,
    timestamp :: Maybe Int,
    -- | dimensionless int type
    value :: Maybe Int,
    error :: Maybe Text
  }
  deriving (Show)

instance FromJSON Measure where
  parseJSON = withObject "Measure" $ \o ->
    Measure <$> o .:? "id"
      <*> o .:? "timestamp"
      <*> o .:? "value"
      <*> o .:? "error"

type BuildTimes = [Measure]

type ClosureSizes = [Measure]

type OutputSizes = [Measure]
