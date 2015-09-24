module DiffFolder.ContentScripts (main) where

-- prelude
import Prelude (Unit (), unit, bind, ($), return)

-- dom
import DOM (DOM ())

-- eff
import Control.Monad.Eff (Eff ())

-- arrays
import qualified Data.Array (head, filterM, null) as A

-- foldable-traversable
import Data.Foldable (traverse_)

-- maybe
import Data.Maybe (Maybe (Just, Nothing))

-- strings
import Data.String.Regex (regex, noFlags, test)

-- simple-dom
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
      titleSpans <- getElementsByClassName "user-select-contain" div
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
