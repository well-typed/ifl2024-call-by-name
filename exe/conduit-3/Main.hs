module Main (main) where

import Data.Dup

import SimplifiedPrelude
import Conduit
import TryAgain

count :: Conduit a Void m Int
count = loop 0
  where
    loop :: Int -> Conduit a Void m Int
    loop !acc =
        let recurse = loop (acc + 1) in
        Await $ \case
          Nothing -> Done acc
          Just _  -> recurse

main :: IO ()
main =
    tryAgainOn UserInterrupt $
      withFile "lotsalines" ReadMode $ \h -> do
        count' <- dupIO count
        let conduit = hGetChars h .| count'
        print =<< run conduit