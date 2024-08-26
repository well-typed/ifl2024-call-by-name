module TryAgain (
    tryAgainOn
  ) where

import Prelude
import Control.Exception

tryAgainOn :: (Exception e, Eq e) => e -> IO a -> IO a
{-# NOINLINE tryAgainOn #-}
tryAgainOn e io =
    io `catch` \e' ->
      if e == e' then io
                 else throwIO e'
