module Main (main) where

import Control.Monad
import Data.Dup

import SimplifiedPrelude
import TryAgain

data Box a = Box a

data Conduit i o m r =
    Done r
  | Yield o (Conduit i o m r)
  | Await (Maybe i -> Box (Conduit i o m r))
  | Lift (m (Conduit i o m r))
  | forall a. Dup (Box a) (a -> Conduit i o m r)

-- | Pull-style composition
(.|) :: Functor m
  => Conduit a b m ()
  -> Conduit b c m r
  -> Conduit a c m r
_         .| Done r    = Done r
Done ()   .| Await r   = Dup (r Nothing)  $ \r' -> Done () .| r'
Yield o l .| Await r   = Dup (r (Just o)) $ \r' -> l       .| r'
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

await :: (Maybe i -> Conduit i o m r) -> Conduit i o m r
await f = Await (\x -> Box (f x))

count :: Conduit a Void m Int
count = loop 0
  where
    loop :: Int -> Conduit a Void m Int
    loop !acc =
        let recurse = loop (acc + 1) in
        await $ \case
          Nothing -> Done acc
          Just _  -> recurse

run :: Conduit Void Void IO r -> IO r
run (Done r)        = return r
run (Lift k)        = k >>= run
run (Dup (Box a) k) = dupIO a >>= run . k
run _               = error "unexpected case"

main :: IO ()
main =
    tryAgainOn UserInterrupt $
      withFile "lotsalines" ReadMode $ \h -> do
        let conduit = hGetChars h .| count
        print =<< run conduit