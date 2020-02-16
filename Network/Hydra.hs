module Network.Hydra
  ( getProjects
  , getProject
  , getJobset
  , getEvals
  , getBuild
  , defaultClientEnv
  )
  where

--------------------------------------------------------------------------------
import Data.Text
import Servant.API
import Servant.Client
import Network.HTTP.Client        (newManager, defaultManagerSettings)
import Network.HTTP.Client.TLS    (tlsManagerSettings)
import System.IO.Unsafe           (unsafePerformIO)
--------------------------------------------------------------------------------
import Network.Hydra.API
--------------------------------------------------------------------------------

-- | Default client environment for Hydra API (constant hostname and port)
defaultClientEnv :: IO ClientEnv
defaultClientEnv = do
  baseUrl <- parseBaseUrl $ "https://hydra.nixos.org:443"
  manager <- newManager tlsManagerSettings
  pure $ mkClientEnv manager baseUrl

(getProjects :<|> getProject :<|> getJobset :<|> getEvals :<|> getBuild)
  = hoistClient hydraApi
    ( fmap (either (error . show) id)
      . flip runClientM (unsafePerformIO defaultClientEnv)
    )
    (client hydraApi)

-- >>> :t getProject
-- getProject :: Text -> IO Network.Hydra.Project.Project


