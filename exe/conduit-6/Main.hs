module Main (main) where

import Control.Monad
import Data.Dup

import SimplifiedPrelude
import TryAgain

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
Done ()   .| Await r   = Done ()   .| r Nothing
Yield o l .| Await r   = l         .| r (Just o)
Lift l    .| Await r   = Lift ((.| Await r) <$> l)
_ .| _ = error "unexpected case"

infixr 2 .|

hGetChars :: Handle -> Conduit Void Char IO ()
hGetChars h = loop
  where
    loop :: Conduit Void Char IO ()
    loop = Lift $ do
        eof <- hIsEOF h
        if eof then return $ Done ()
               else do c <- hGetChar h
                       return $ Yield c loop

count :: Conduit a Void m Int
count = loop 0
  where
    loop :: Int -> Conduit a Void m Int
    loop !acc =
        let recurse = loop (acc + 1) in
        Await $ \case
          Nothing -> Done acc
          Just _  -> recurse

run :: Conduit Void Void IO r -> IO r
run = dupIO >=> \case
        Done r -> return r
        Lift k -> k >>= run
        _ -> error "unexpected case"

main :: IO ()
main =
    tryAgainOn UserInterrupt $
      withFile "lotsalines" ReadMode $ \h -> do
        let conduit = hGetChars h .| count
        print =<< run conduit