module Main where

import Prelude --(Unit())
import DOM (DOM())
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Console (CONSOLE(), log)
import Data.DOM.Simple.Document (Document, title)
import Data.DOM.Simple.Element (getElementsByClassName)
import Data.DOM.Simple.Window (document, globalWindow)

main :: forall e. Eff (dom :: DOM, console :: CONSOLE | e) Unit
main = do
  doc <- document globalWindow
  t <- title doc
  log t
--  fileDivs <- getElementsByClassName "file" doc
--  log fileDivs


-- getElementsByClassName :: forall eff. String -> b -> Eff (dom :: DOM | eff) (Array HTMLElement)
