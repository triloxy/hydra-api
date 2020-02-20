{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Hydra.API
  ( HydraAPI(..)
  , hydraApi
  )
  where

--------------------------------------------------------------------------------
import Data.Proxy
import Data.Text
import Data.Aeson
import Servant.API
--------------------------------------------------------------------------------
import qualified Network.Hydra.Project  as Hydra
import qualified Network.Hydra.Jobset   as Hydra
import qualified Network.Hydra.Eval     as Hydra
import qualified Network.Hydra.Build    as Hydra
import qualified Network.Hydra.Measures as Hydra
--------------------------------------------------------------------------------

type HydraAPI
  = -- list of projects
       Get '[JSON] [Hydra.Project]
       
    -- Get a project
  :<|> "project" 
       :> Capture "project" Text 
       :> Get '[JSON] Hydra.Project
       
    -- Get a jobset
  :<|> "jobset"
       :> Capture "project" Text
       :> Capture "jobset"  Text
       :> Get '[JSON] Hydra.Jobset
       
    -- Get evaluations
  :<|> "jobset"
       :> Capture "project" Text
       :> Capture "jobset"  Text
       :> "evals"
       :> Get '[JSON] Hydra.Evals
       
    -- Get build information
  :<|> "build"
       :> Capture "buildno" Int
       :> Get '[JSON] Hydra.Build
    -- Measure API
  :<|> "job"
       :> Capture "project" Text
       :> Capture "jobset"  Text
       :> Capture "attribute" Text
       :> "build-times"
       :> Get '[JSON] Hydra.BuildTimes

  :<|> "job"
       :> Capture "project" Text
       :> Capture "jobset"  Text
       :> Capture "attribute" Text
       :> "closure-sizes"
       :> Get '[JSON] Hydra.ClosureSizes

  :<|> "job"
       :> Capture "project" Text
       :> Capture "jobset"  Text
       :> Capture "attribute" Text
       :> "output-sizes"
       :> Get '[JSON] Hydra.OutputSizes


hydraApi :: Proxy HydraAPI
hydraApi = Proxy

