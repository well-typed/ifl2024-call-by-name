module Main (main) where

import SimplifiedPrelude

{-# NOINLINE printSecret #-}
printSecret :: IO ()
printSecret =
  let ns = enumFrom zero in
  IO $ \w0 ->
    case unIO readLn w0 of
      (# w1, i #) ->
        unIO (print (ns!!i)) w1

main :: IO ()
main = replicateM_ 3 printSecret
