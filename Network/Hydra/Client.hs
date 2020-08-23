module Network.Hydra.Client where

--------------------------------------------------------------------------------

import Data.Text
--------------------------------------------------------------------------------

import Network.Hydra.API
import qualified Network.Hydra.Build as Hydra
import qualified Network.Hydra.Eval as Hydra
import qualified Network.Hydra.Jobset as Hydra
import qualified Network.Hydra.Measures as Hydra
import qualified Network.Hydra.Project as Hydra
import Servant.API
import Servant.Client

--------------------------------------------------------------------------------

-- Hydra API Client Implementation

getProjects :: ClientM [Hydra.Project]
getProject :: Text -> ClientM Hydra.Project
getJobset :: Text -> Text -> ClientM Hydra.Jobset
getEvals :: Text -> Text -> ClientM Hydra.Evals
getBuild :: Int -> ClientM Hydra.Build
-- TODO: Implement metrics
getBuildTimes :: Text -> Text -> Text -> ClientM Hydra.BuildTimes
getClosureSizes :: Text -> Text -> Text -> ClientM Hydra.ClosureSizes
getOutputSizes :: Text -> Text -> Text -> ClientM Hydra.OutputSizes
(getProjects :<|> getProject :<|> getJobset :<|> getEvals :<|> getBuild :<|> getBuildTimes :<|> getClosureSizes :<|> getOutputSizes) = client hydraApi
