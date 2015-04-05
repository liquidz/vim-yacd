" Yet Another Changing Directory
" Version: 1.0
" Author: uochan <liquidz.uo@gmail.com>
" License: MIT LICENSE

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:yacd#enable')
  let g:yacd#enable = 1
endif

if !exists('g:yacd#root_names')
  let g:yacd#root_names = ['Rakefile', '.git']
endif

let s:V = vital#of('vital')
let s:FilePath = s:V.import('System.Filepath')

function! yacd#find_root_dir(dir, root_names)
  for name in a:root_names
    let path = s:FilePath.join(a:dir, name)
    if filereadable(path) || isdirectory(path)
      return a:dir
    endif
  endfor

  return (a:dir == '/')
        \ ? ''
        \ : yacd#find_root_dir(s:FilePath.dirname(a:dir), a:root_names)
endfunction

function! yacd#cd_to_root()
  if g:yacd#enable
    let root_dir = yacd#find_root_dir(getcwd(), g:yacd#root_names)
    if root_dir !=# ''
      execute ':lcd ' . fnameescape(root_dir)
    else
      " ルート・ディレクトリが見つからない場合は
      " 開いているファイルのあるディレクトリへcd
      execute ':lcd ' . expand("%:p:h")
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
