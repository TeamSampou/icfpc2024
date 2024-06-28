{-# LANGUAGE OverloadedStrings #-}
module Client where

import Data.Char (chr, ord)
import Data.Maybe (mapMaybe)
import qualified Data.ByteString.Lazy.Char8 as LBS
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Client (defaultManagerSettings, RequestBody (RequestBodyLBS))

token = "Bearer 39572a1c-b861-4e57-8405-b9fda4f8cec3"

postEncoded :: String -> IO String
postEncoded str = do
  manager <- newManager tlsManagerSettings
  initReq <- parseRequest "https://boundvariable.space/communicate"
  let req = initReq { method = "POST"
                    , requestHeaders = [( "Authorization"
                                        , token)]
                    , requestBody = RequestBodyLBS (LBS.pack str)
                    }
  resp <- httpLbs req manager
  let body = responseBody resp
  return $ decode $ tail $ LBS.unpack body

simplePost :: String -> IO String
simplePost raw = do
  let msg = encode' raw
  print "===================="
  print $ "SEND: " ++ msg
  print "===================="
  manager <- newManager tlsManagerSettings
  initReq <- parseRequest "https://boundvariable.space/communicate"
  let req = initReq { method = "POST"
                    , requestHeaders = [( "Authorization"
                                        , token)]
                    , requestBody = RequestBodyLBS (LBS.pack msg)
                    }
  resp <- httpLbs req manager
  let body = LBS.unpack $ responseBody resp
  print "===================="
  print $ "RECV: " ++ body
  print "===================="
  return $ decode $ tail body

-------

parse :: String -> String
parse = concatMap decode . words

printMessage :: String -> IO ()
printMessage f = do
  s <- readFile f
  putStrLn $ parse s

{- |
>>> int "/6"
1337
-}
int :: String -> Int
int = foldl (\acc c -> acc * 94 + ord c - ord '!') 0

decode :: String -> String
decode = mapMaybe $ flip lookup dict

encode :: String -> String
encode = mapMaybe $ flip lookup dict'
  where dict' = map swap dict
        swap (a, b) = (b, a)

encode' = ('S':) . encode

dict = zip cultCode humanReadable
  where
    cultCode = map chr [33..126]
    humanReadable = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`|~ \n"

-- hello world
test = "B%,,/}Q/2,$_"

-- curl -X POST -H 'Authorization: Bearer 39572a1c-b861-4e57-8405-b9fda4f8cec3' https://boundvariable.space/communicate
communicate = "J!23%}%22/2n}O.%80%#4%$}?I@"

ex1 = do
  str <- readFile "answer1"
  return $ tail str

ex2 = do
  str <- readFile "answer2"
  return $ tail str

