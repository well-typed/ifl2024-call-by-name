module Main (main) where

import SimplifiedPrelude

{-# NOINLINE printSecret #-}
printSecret :: IO ()
printSecret = do
    let ns = enumFrom zero
    i <- readLn
    print (ns!!i)

main :: IO ()
main = replicateM_ 3 printSecret
