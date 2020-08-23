{-# LANGUAGE OverloadedStrings #-}

-- | Please consider importing like this:
--     import Network.Hydra.Project as Hydra
module Network.Hydra.Project where

--------------------------------------------------------------------------------

import Data.Aeson
import Data.Text
import Network.Hydra.Internal.Utils as U

--------------------------------------------------------------------------------

data Project = Project
  { displayName :: Text,
    description :: Text,
    releases :: [Text],
    enabled :: Bool,
    name :: Text,
    owner :: Text,
    hidden :: Bool,
    jobsets :: [Text]
  }
  deriving (Show)

instance FromJSON Project where
  parseJSON =
    withObject "Project" $ \o ->
      Project <$> o .: "displayname"
        <*> o .: "description"
        <*> o .: "releases"
        <*> (U._int2Bool <$> (o .: "enabled"))
        <*> o .: "name"
        <*> o .: "owner"
        <*> (U._int2Bool <$> (o .: "hidden"))
        <*> o .: "jobsets"
