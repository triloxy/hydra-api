{-# LANGUAGE OverloadedStrings #-}

module Network.Hydra
  ( getProjects,
    getProject,
    getJobset,
    getEvals,
    getBuild,
    getBuildTimes,
    getClosureSizes,
    getOutputSizes,
    defaultClientEnv,
  )
where

--------------------------------------------------------------------------------
import Data.Text
import Network.HTTP.Client (defaultManagerSettings, newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
--------------------------------------------------------------------------------
import Network.Hydra.API
import Servant.API
import Servant.Client
import System.IO.Unsafe (unsafePerformIO)

--------------------------------------------------------------------------------

-- | Default client environment for Hydra API (constant hostname and port)
defaultClientEnv :: IO ClientEnv
defaultClientEnv = do
  baseUrl <- parseBaseUrl "https://hydra.nixos.org:443"
  manager <- newManager tlsManagerSettings
  pure $ mkClientEnv manager baseUrl

(getProjects :<|> getProject :<|> getJobset :<|> getEvals :<|> getBuild :<|> getBuildTimes :<|> getClosureSizes :<|> getOutputSizes) =
  hoistClient
    hydraApi
    ( fmap (either (error . show) id)
        . flip runClientM (unsafePerformIO defaultClientEnv)
    )
    (client hydraApi)
