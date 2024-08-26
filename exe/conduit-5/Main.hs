module Main (main) where

import Data.Dup

import SimplifiedPrelude
import Conduit
import TryAgain

count :: Conduit a Void IO Int
count = loop 0
  where
    loop :: Int -> Conduit a Void IO Int
    loop !acc = Lift $ do
        recurse <- dupIO $ loop (acc + 1)
        return $
          Await $ \case
            Nothing -> Done acc
            Just _  -> recurse

main :: IO ()
main =
    tryAgainOn UserInterrupt $
      withFile "lotsalines" ReadMode $ \h -> do
        let conduit = hGetChars h .| count
        print =<< run conduit