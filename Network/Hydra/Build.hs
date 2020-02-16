{-# LANGUAGE OverloadedStrings #-}

module Network.Hydra.Build
  where

--------------------------------------------------------------------------------
import Data.Aeson
import Data.Text
import qualified Data.Map.Strict     as M
import qualified Data.HashMap.Strict as HM
--------------------------------------------------------------------------------
import Network.Hydra.Internal.Utils (_int2Bool)
--------------------------------------------------------------------------------
{-
  Nix derivations can have multiple outputs like `out`, `dev`, `doc`
  etc. We represent those outputs via a Map.
-}

type OutputName  = Text
type OutputValue = Text
type BuildOutput = M.Map OutputName OutputValue

{-

  Example build products as an object:

    "buildproducts": {
        "1": {
          "path": "/nix/store/lzrxkjc35mhp8w7r8h82g0ljyizfchma-vm-test-run-unnamed",
          "sha1hash": null,
          "defaultpath": "log.html",
          "type": "report",
          "sha256hash": null,
          "filesize": null,
          "name": "",
          "subtype": "testlog"
        }
      }
-}

data BuildProduct
  = BuildProduct { path             :: FilePath
                 , defaultPath      :: Text
                 , name             :: Text
                 , buildProductType :: Text
                 , subtype          :: Text
                 , sha1hash         :: Maybe Text
                 , sha256hash       :: Maybe Text
                 , filesize         :: Maybe Text
                 } deriving (Show)

instance FromJSON BuildProduct where
  parseJSON = withObject "BuildProduct" $ \o ->
    BuildProduct <$> o .:  "path"
                 <*> o .:  "defaultpath"
                 <*> o .:  "name"
                 <*> o .:  "type"
                 <*> o .:  "subtype"
                 <*> o .:? "sha1hash"
                 <*> o .:? "sha256hash"
                 <*> o .:? "filesize"

data Build
  = Build { buildId       :: Int
          , project       :: Text
          , jobset        :: Text
          , job           :: Text
          , startTime     :: Int
          , stopTime      :: Int
          , releaseName   :: Maybe Text
          , buildOutputs  :: M.Map Text BuildOutput
          , buildProducts :: M.Map Int BuildProduct
          , buildStatus   :: Int
          -- , buildMetrics  :: Maybe Text
          , system        :: Text
          , timestamp     :: Int
          , priority      :: Int
          , finised       :: Bool
          , jobsetEvals   :: [Int]
          , drvPath       :: Text
          , nixname       :: Text
          } deriving (Show)

instance FromJSON Build where
  parseJSON = withObject "Build" $ \o ->
    Build <$> o .:  "id"
          <*> o .:  "project"
          <*> o .:  "jobset"
          <*> o .:  "job"
          <*> o .:  "starttime"
          <*> o .:  "stoptime"
          <*> o .:? "releasename"
          <*> (M.fromList . HM.toList <$> o .: "buildoutputs")
          <*> (M.fromList . HM.toList <$> o .: "buildproducts")
          <*> o .:  "buildstatus"
          -- <*> o .:? "buildmetrics"
          <*> o .:  "system"
          <*> o .:  "timestamp"
          <*> o .:  "priority"
          <*> ( _int2Bool <$> o .:  "finished")
          <*> o .:  "jobsetevals"
          <*> o .:  "drvpath"
          <*> o .:  "nixname"
          
