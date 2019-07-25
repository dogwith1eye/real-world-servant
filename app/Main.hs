{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Import
import Run
import RIO.Process
import Options.Applicative.Simple
import qualified Paths_real_world_servant
import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool)

main :: IO ()
main = do
  (options, ()) <- simpleOptions
    $(simpleVersion Paths_real_world_servant.version)
    "Header for command line arguments"
    "Program description, also for command line arguments"
    (Options
       <$> switch ( long "verbose"
                 <> short 'v'
                 <> help "Verbose output?"
                  )
    )
    empty
  lo <- logOptionsHandle stderr (optionsVerbose options)
  pc <- mkDefaultProcessContext
  pool <- createPostgresqlPool "host=localhost dbname=perservant user=test password=test port=5432" 1
  withLogFunc lo $ \lf ->
    let app = App
          { appLogFunc = lf
          , appProcessContext = pc
          , appOptions = options
          , appPort = 8080
          , appPool = pool
          }
     in runRIO app startApp
