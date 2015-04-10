" Yet Another Changing Directory
" Version: 1.1
" Author: uochan <liquidz.uo@gmail.com>
" License: MIT LICENSE

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:yacd#enable')
  let g:yacd#enable = 0
endif

if !exists('g:yacd#root_names')
  let g:yacd#root_names = ['Rakefile', '.git']
endif

let s:V = vital#of('vital')
let s:FilePath = s:V.import('System.Filepath')

function! yacd#get_root_dir(dir, ...)
  let names = (len(a:000) == 0) ? g:yacd#root_names : a:000[0]
  for name in names
    let path = s:FilePath.join(a:dir, name)
    if filereadable(path) || isdirectory(path)
      return a:dir
    endif
  endfor

  return (a:dir == '/')
        \ ? ''
        \ : yacd#get_root_dir(s:FilePath.dirname(a:dir), names)
endfunction

function! yacd#cd_to_root()
  if g:yacd#enable
    let root_dir = yacd#get_root_dir(getcwd())
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
