{-# LANGUAGE OverloadedStrings #-}

module Network.Hydra.Client
  where

--------------------------------------------------------------------------------
import Servant.API
import Servant.Client
import Data.Text
--------------------------------------------------------------------------------
import qualified Network.Hydra.Project as Hydra
import qualified Network.Hydra.Jobset  as Hydra
import qualified Network.Hydra.Eval    as Hydra
import qualified Network.Hydra.Build   as Hydra
import           Network.Hydra.API
--------------------------------------------------------------------------------

-- Hydra API Client Implementation

getProjects :: ClientM [Hydra.Project]
getProject  :: Text -> ClientM Hydra.Project
getJobset   :: Text -> Text -> ClientM Hydra.Jobset
getEvals    :: Text -> Text -> ClientM Hydra.Evals
getBuild    :: Int -> ClientM Hydra.Build

(getProjects :<|> getProject :<|> getJobset :<|> getEvals :<|> getBuild) = client hydraApi
