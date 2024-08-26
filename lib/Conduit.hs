{-# OPTIONS -fno-full-laziness #-}

-- | Simplified conduit API
--
-- Intended for unqualified import.
module Conduit (
    Conduit(..)
  , (.|)
  , run
    -- Specific conduits
  , hGetChars
  ) where

import Data.Void
import Prelude
import System.IO

{-------------------------------------------------------------------------------
  Simplified Conduit definition
-------------------------------------------------------------------------------}

data Conduit i o m r =
    Done r
  | Yield o (Conduit i o m r)
  | Await (Maybe i -> Conduit i o m r)
  | Lift (m (Conduit i o m r))

-- | Pull-style composition
(.|) :: Functor m
  => Conduit a b m ()
  -> Conduit b c m r
  -> Conduit a c m r
_         .| Done r    = Done r
l         .| Yield o r = Yield o (l .| r)
l         .| Lift r    = Lift ((l .|) <$> r)
Done ()   .| Await r   = Done ()   .| r Nothing
Yield o l .| Await r   = l         .| r (Just o)
Await l   .| Await r   = Await (\x -> l x .| Await r)
Lift l    .| Await r   = Lift ((.| Await r) <$> l)

infixr 2 .|

run :: Monad m => Conduit Void Void m r -> m r
run (Done r)    = return r
run (Yield o _) = absurd o
run (Await k)   = run $ k Nothing
run (Lift k)    = k >>= run

{-------------------------------------------------------------------------------
  Specific conduits
-------------------------------------------------------------------------------}

hGetChars :: Handle -> Conduit Void Char IO ()
hGetChars h = loop
  where
    loop :: Conduit Void Char IO ()
    loop = Lift $ do
        eof <- hIsEOF h
        if eof then return $ Done ()
               else do c <- hGetChar h
                       return $ Yield c loop
