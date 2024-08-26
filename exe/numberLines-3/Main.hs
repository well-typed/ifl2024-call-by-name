module Main (main) where

import SimplifiedPrelude
import TryAgain

numberLine :: Int -> String -> IO ()
{-# NOINLINE numberLine #-}
numberLine n xs = putStrLn $ show n ++ ": " ++ xs

{-# NOINLINE noop #-}
noop :: IO ()
noop = return ()

{-# NOINLINE numberLines #-}
numberLines :: IO ()
numberLines = do
    let ns = enumFrom zero
    noop
    loop ns
  where
    loop :: [Int] -> IO ()
    loop []     = undefined
    loop (n:ns) = do
        eof <- hIsEOF stdin
        if eof then return ()
               else do xs <- hGetLine stdin
                       numberLine n xs
                       loop ns

main :: IO ()
main = do
    tryAgainOn UserInterrupt $
      numberLines