{-# LANGUAGE NoImplicitPrelude #-}
module Types where

import RIO
import RIO.Process

import Database.Persist.Postgresql (ConnectionPool)

-- | Command line arguments
data Options = Options
  { optionsVerbose :: !Bool
  }

data App = App
  { appLogFunc        :: !LogFunc
  , appProcessContext :: !ProcessContext
  , appOptions        :: !Options
  , appPort           :: !Int
  , appPool           :: !ConnectionPool
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x { appLogFunc = y })
instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x { appProcessContext = y })

class HasPort env where
  portL :: env -> Int
instance HasPort Int where
  portL = id
instance HasPort App where
  portL = appPort