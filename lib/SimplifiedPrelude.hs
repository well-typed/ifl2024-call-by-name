-- | Simplified prelude
--
-- Everything defined is an alias for something defined in the regular prelude,
-- but with simplified types: no ad-hoc polymorphism, no callstacks, etc. The
-- goal is to keep the generated core as readable and clean as possible.
module SimplifiedPrelude (
    module Prelude
  , module Control.Exception
  , module Data.Void
  , module GHC.IO
  , module System.IO
  , (!!)
  , enumFrom
  , hGetLine
  , hIsEOF
  , print
  , putStrLn
  , readLn
  , replicateM_
  , undefined
  , zero
  ) where

import Prelude hiding (print, readLn, (!!), enumFrom, undefined, putStrLn)
import Prelude qualified as Base

import Control.Exception
import Control.Monad qualified as Base
import Data.Void
import GHC.IO (IO(IO), unIO)
import System.IO hiding (print, readLn, hIsEOF, hGetLine, putStrLn)
import System.IO qualified as Base

print :: Int -> IO ()
{-# NOINLINE print #-}
print = Base.print

readLn :: IO Int
{-# NOINLINE readLn #-}
readLn = Base.readLn

(!!) :: [Int] -> Int -> Int
{-# NOINLINE (!!) #-}
(!!) = (Base.!!)

enumFrom :: Int -> [Int]
{-# NOINLINE enumFrom #-}
enumFrom = Base.enumFrom

zero :: Int
{-# NOINLINE zero #-}
zero = 0

replicateM_ :: Applicative m => Int -> m a -> m ()
{-# NOINLINE replicateM_ #-}
replicateM_ = Base.replicateM_

undefined :: a
{-# NOINLINE undefined #-}
undefined = Base.undefined

hIsEOF :: Handle -> IO Bool
{-# NOINLINE hIsEOF #-}
hIsEOF = Base.hIsEOF

hGetLine :: Handle -> IO String
{-# NOINLINE hGetLine #-}
hGetLine = Base.hGetLine

putStrLn :: String -> IO ()
{-# NOINLINE putStrLn #-}
putStrLn = Base.putStrLn