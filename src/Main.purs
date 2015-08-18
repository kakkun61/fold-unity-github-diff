module Main (main, expand) where

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
import Data.DOM.Simple.Events
import Data.DOM.Simple.Types
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
      tid <- S.drop 5 <$> getAttribute "id" div
      tables <- getElementsByClassName "diff-table" div
      case A.head tables of
        Just table -> do
          tbodies <- children table
          case A.head tbodies of
            Just tbody -> do
              setAttribute "id" (origId tid) tbody
              setStyleAttr "display" "none" tbody
            Nothing -> return unit
          gcTbody <- createGcTbody tid doc
          appendChild table gcTbody
          ma <- getElementById (expandId tid) doc
          case ma of
            Just a -> addMouseEventListener MouseClickEvent (const (expand tid) :: forall e. DOMEvent -> Eff (dom :: DOM | e) Unit) a
            Nothing -> return unit
        Nothing -> return unit
      where
        createGcTbody tid doc = do
          tbody <- createElement "tbody" doc
          setAttribute "id" (replId tid) tbody
          let template = "<tr class=\"js-expandable-line\" data-position=\"0\">\n\
                         \  <td class=\"blob-num blob-num-expandable\" style=\"width: 99px;\">\n\
                         \    <a id=\"{id}\" class=\"diff-expander\" title=\"Expand\" aria-label=\"Expand\">\n\
                         \      <span class=\"octicon octicon-unfold\"></span>\n\
                         \    </a>\n\
                         \  </td>\n\
                         \  <td class=\"blob-code blob-code-hunk\"></td>\n\
                         \  </tr>\n\
                         \</tr>"
              pattern = regex "\\{id\\}" noFlags
          setInnerHTML
            (replace pattern (expandId tid) template)
            tbody
          return tbody

origId = ("orig-" ++)
replId = ("repl-" ++)
expandId = ("expand-" ++)

expand tid = do
  doc <- document globalWindow
  origTBodies <- getElementsByClassName (origId tid) doc
  replTBodies <- getElementsByClassName (replId tid) doc
  case A.head origTBodies of
    Just origTBody ->
      case A.head replTBodies of
        Just replTBody -> do
          setStyleAttr "display" "none" replTBody
          setStyleAttr "display" "block" origTBody
        Nothing -> return unit
    Nothing -> return unit
