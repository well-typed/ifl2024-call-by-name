module Main (main) where

import SimplifiedPrelude
import Conduit
import TryAgain

count :: Conduit a Void m Int
count = loop 0
  where
    loop :: Int -> Conduit a Void m Int
    loop !acc =

        Await $ \case
          Nothing -> Done acc
          Just _  -> loop (acc + 1)

main :: IO ()
main =
    tryAgainOn UserInterrupt $
      withFile "lotsalines" ReadMode $ \h -> do
        let conduit = hGetChars h .| count
        print =<< run conduit