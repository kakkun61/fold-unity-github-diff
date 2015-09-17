module Main (main) where

import Prelude (Unit (), unit, bind, ($), return)
import DOM (DOM ())
import Control.Monad.Eff (Eff ())
import qualified Data.Array (head, filterM, null) as A
import Data.Foldable (traverse_)
import Data.Maybe (Maybe (Just, Nothing))
import Data.String.Regex (regex, noFlags, test)
import Data.DOM.Simple.Document (createElement)
import Data.DOM.Simple.Element (getElementsByClassName, getAttribute, setAttribute, setInnerHTML, appendChild, classAdd)
import Data.DOM.Simple.Window (document, globalWindow)

main :: Eff (dom :: DOM) Unit
main = do
  doc <- document globalWindow
  fileDivs <- getElementsByClassName "file" doc
  shouldFoldFileDivs <- A.filterM shouldFold fileDivs
  traverse_ (collapse doc) shouldFoldFileDivs
  where
    shouldFold div = do
      titleSpans <- getElementsByClassName "js-selectable-text" div
      case A.head titleSpans of
        Just titleSpan -> do
          title <- getAttribute "title" titleSpan
          let pattern = regex "(\\.unity|\\.prefab)$" noFlags
          return $ test pattern title
        Nothing -> return false
    collapse doc div = do
      dataDivs <- getElementsByClassName "data" div
      if A.null dataDivs
        then return unit
        else
          case A.head dataDivs of
            Just dataDiv -> do
              classAdd "suppressed" dataDiv
              image <- createImageDiv doc
              appendChild div image
            Nothing -> return unit
      where
        createImageDiv doc = do
          div <- createElement "div" doc
          setAttribute "class" "image" div
          setInnerHTML
            "<a href=\"#\" class=\"js-details-target\">Diff suppressed. Click to show.</a>"
            div
          return div
