module Main where

import Prelude
import DOM
import Control.Monad.Eff
import Control.Monad.Eff.Console
import qualified Data.Array as A
import Data.Foldable
import Data.Maybe
import qualified Data.String as S
import Data.String.Regex
import Data.DOM.Simple.Document
import Data.DOM.Simple.Element
import Data.DOM.Simple.Window hiding (search)

--main :: forall e. Eff (dom :: DOM, console :: CONSOLE | e) Unit
main = do
  print "fold Unity GitHub diff"
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
          let pattern = regex "(\\.unity|\\.meta|\\.prefab)$" noFlags
          return $ test pattern title
        Nothing -> return false
    collapse doc div = do
      tbodyId <- ("orig-" ++) <<< (S.drop 5) <$> getAttribute "id" div
      tables <- getElementsByClassName "diff-table" div
      case A.head tables of
        Just table -> do
          tbodies <- children table
          case A.head tbodies of
            Just tbody -> do
              setAttribute "id" tbodyId tbody
              setStyleAttr "display" "none" tbody
            Nothing -> return unit
          gcTbody <- createGcTbody doc
          appendChild table gcTbody
        Nothing -> return unit
      where
        createGcTbody doc = do
          tbody <- createElement "tbody" doc
          setInnerHTML
            "<tr class=\"file-diff-line gc\">\n\
            \  <td class=\"diff-line-num expandable-line-num\" colspan=\"2\">\n\
            \    <span class=\"diff-expander js-expand\" title=\"Expand\" aria-label=\"Expand\">\n\
            \      <span class=\"octicon octicon-unfold\"></span>\n\
            \    </span>\n\
            \  </td>\n\
            \  <td class=\"diff-line-code\"></td>\n\
            \</tr>"
            tbody
          return tbody


-- getElementsByClassName :: forall eff. String -> b -> Eff (dom :: DOM | eff) (Array HTMLElement)
