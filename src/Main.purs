module Main where

import Prelude
import DOM
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Data.Array
import Data.Foldable
import Data.Maybe
import Data.String.Regex
import Data.DOM.Simple.Document
import Data.DOM.Simple.Element
import Data.DOM.Simple.Window

--main :: forall e. Eff (dom :: DOM, console :: CONSOLE | e) Unit
main = do
  print "fold Unity GitHub diff"
  doc <- document globalWindow
  fileDivs <- getElementsByClassName "file" doc
  traverse_ eachFile fileDivs
  where
    eachFile div = do
      titleSpans <- getElementsByClassName "js-selectable-text" div
      case head titleSpans of
        Just titleSpan -> do
          title <- getAttribute "title" titleSpan
          print title
          let pattern = regex "(\\.unity|\\.meta|\\.prefab)$" noFlags
          print $ test pattern title
        Nothing -> return unit


-- getElementsByClassName :: forall eff. String -> b -> Eff (dom :: DOM | eff) (Array HTMLElement)
