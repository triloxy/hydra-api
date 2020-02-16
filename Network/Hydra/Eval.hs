{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections     #-}

module Network.Hydra.Eval
  where

--------------------------------------------------------------------------------
import Data.Text
import Data.Aeson
import Data.Aeson.Types (Parser)
import Network.Hydra.Internal.Utils
import Data.Map.Strict               as M
import qualified Data.List           as L
import qualified Data.HashMap.Strict as HM
--------------------------------------------------------------------------------

data Input
  = Input { inputType  :: Text -- Valid values are limited "build, boolean, git, etc..." 
          , value      :: Maybe Text
          , uri        :: Maybe Text
          , revision   :: Maybe Text
          , dependency :: Maybe Int -- build ID of the input, for type == 'build'
          } deriving (Show)

type EvalInputs = M.Map Text Input

data Eval
  = Eval { id               :: Int
         , jobsetEvalInputs :: EvalInputs
         , hasNewBuilds     :: Bool
         , builds           :: [Int]
         } deriving (Show)

instance FromJSON Eval where
  parseJSON = withObject "Eval" $ \o ->
    Eval <$> o .: "id"
         <*> ((o .: "jobsetevalinputs") >>= parseInputs)
         <*> (_int2Bool   <$> (o .: "hasnewbuilds"))
         <*> o .: "builds"

parseInputs :: HM.HashMap Text Value -> Parser EvalInputs
parseInputs m
  = M.fromList <$> (mapM parseInput . HM.toList $ m)

parseInput :: (Text, Value) -> Parser (Text, Input)
parseInput (t, v)
  = withObject "Input" (\o ->
      (t,) <$> (Input <$> o .: "type"
                      <*> o .:? "value"
                      <*> o .:? "uri"
                      <*> o .:? "revision"
                      <*> o .:? "dependency")) v

data Evals
  = Evals { evals :: [Eval] }
  deriving Show

instance FromJSON Evals where
  parseJSON = withObject "Evals" (\o -> Evals <$> (o .: "evals"))
    
