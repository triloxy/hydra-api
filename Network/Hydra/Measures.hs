{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections     #-}

module Network.Hydra.Measures
  ( BuildTimes(..)
  , OutputSizes(..)
  , ClosureSizes(..)
  )
  where

--------------------------------------------------------------------------------
import Data.Text
import Data.Aeson
import Data.Aeson.Types              (Parser)
import Network.Hydra.Internal.Utils
import Data.Map.Strict               as M
import qualified Data.List           as L
import qualified Data.HashMap.Strict as HM
--------------------------------------------------------------------------------

data Measure
  = Measure { buildId   :: Maybe Int
            , timestamp :: Maybe Int
            , value     :: Maybe Int  -- ^ dimensionless int type
            , error     :: Maybe Text
            } deriving (Show)

instance FromJSON Measure where
  parseJSON = withObject "Measure" $ \o ->
    Measure <$> o .:? "id"
            <*> o .:? "timestamp"
            <*> o .:? "value"
            <*> o .:? "error"

type BuildTimes   = [ Measure ]
type ClosureSizes = [ Measure ]
type OutputSizes  = [ Measure ]

