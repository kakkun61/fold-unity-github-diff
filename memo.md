div.meta clearfix の data-path でファイル名が分かる

div.meta clearfix
div.data highlight
  table.file-code file-diff  tab-size-8
    tbody
      ← ここを↓にする

  <tr class="file-diff-line gc">
   <td class="diff-line-num expandable-line-num" colspan="2">
     <span class="diff-expander js-expand" title="Expand" aria-label="Expand">
       <span class="octicon octicon-unfold"></span>
     </span>
   </td>
   <td class="diff-line-code"></td>
  </tr>

js-expand をやめて直接 onclick イベントを拾う