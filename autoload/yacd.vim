" Yet Another Changing Directory
" Version: 1.2
" Author: uochan <liquidz.uo+vim@gmail.com>
" License: MIT LICENSE

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:yacd#enable')
  let g:yacd#enable = 0
endif

if !exists('g:yacd#root_names')
  let g:yacd#root_names = ['.svn', '.git']
endif

let s:V = vital#of('vital')
let s:FilePath = s:V.import('System.Filepath')

function! s:is_system_root(dir)
  return (has('win32'))
      \ ? (match(a:dir, '\c^[A-Z]:\\$') ==# 0)
      \ : (a:dir ==# s:FilePath.separator())
endfunction

function! yacd#get_root_dir(dir, ...)
  let names = (len(a:000) == 0) ? g:yacd#root_names : a:000[0]
  for name in names
    let path = s:FilePath.join(a:dir, name)
    if filereadable(path) || isdirectory(path)
      return a:dir
    endif
  endfor

  return (s:is_system_root(a:dir))
        \ ? ''
        \ : yacd#get_root_dir(s:FilePath.dirname(a:dir), names)
endfunction

function! yacd#cd_to_root()
  if g:yacd#enable
    if exists('b:yacd_buf_dir')
      let cwd = getcwd()
      let root_dir = yacd#get_root_dir(b:yacd_buf_dir)
      " quickrun などで一時的にルートディレクトリへ遷移している場合があるので
      " カレントディレクトリがルートディレクトリの場合は lcd しない
      if cwd !=# root_dir
        execute ':lcd ' . fnameescape(b:yacd_buf_dir)
      endif
    else
      " 初回の BufEnter 時には開いたファイルがあるディレクトリへ lcd
      let b:yacd_buf_dir = expand('%:p:h')
      execute ':lcd ' . expand(b:yacd_buf_dir)
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
