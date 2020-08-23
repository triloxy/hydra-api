{-# LANGUAGE OverloadedStrings #-}

-- | Please consider importing like this:
--     import Network.Hydra.Project as Hydra
module Network.Hydra.Jobset (Jobset (..)) where

--------------------------------------------------------------------------------
import Data.Aeson
import qualified Data.HashMap.Strict as HM
import qualified Data.Map.Strict as M
import Data.Text
import Network.Hydra.Internal.Utils as U

--------------------------------------------------------------------------------
newtype JobsetInput = JobsetInput {jobsetInputAlts :: [Text]}
  deriving (Show)

instance FromJSON JobsetInput where
  parseJSON =
    withObject "JobsetInput" $ \o ->
      JobsetInput <$> o .: "jobsetinputalts"

data Jobset = Jobset
  { emailOverride :: Text,
    errorMsg :: Text,
    fetchErrorMsg :: Maybe Text,
    enabled :: Bool,
    jobsetInputs :: M.Map Text JobsetInput,
    nixExprInput :: Text,
    nixExprPath :: Text
  }
  deriving (Show)

instance FromJSON Jobset where
  parseJSON =
    withObject "Jobset" $ \o ->
      Jobset <$> o .: "emailoverride"
        <*> o .: "errormsg"
        <*> o .:? "fetcherrormsg"
        <*> (U._int2Bool <$> (o .: "enabled"))
        <*> (M.fromList . HM.toList <$> o .: "jobsetinputs")
        <*> o .: "nixexprinput"
        <*> o .: "nixexprpath"
