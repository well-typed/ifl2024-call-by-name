module Main (main) where

import SimplifiedPrelude

{-# NOINLINE printSecret #-}
printSecret :: IO ()
printSecret =
  IO $ \w0 ->
    let ns = enumFrom zero in
    case unIO readLn w0 of
      (# w1, i #) ->
        unIO (print (ns!!i)) w1

main :: IO ()
main = replicateM_ 3 printSecret
