{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run)

application _ respond = respond $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello World"

main = run 8080 application
