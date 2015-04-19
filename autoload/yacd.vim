""
" Yet Another Changing Directory Plugin
"

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('yacd')
let s:FilePath = s:V.import('System.Filepath')

""
" @var
" Set 1 to enable this plugin.
" Default value is 0.
"
if !exists('g:yacd#enable')
  let g:yacd#enable = 0
endif

""
" @var
" File or directory list that specify a root directory.
" Default value is ['.svn', '.git'].
"
if !exists('g:yacd#root_names')
  let g:yacd#root_names = ['.svn', '.git']
endif

function! s:is_system_root(dir) abort
  return (has('win32'))
      \ ? (match(a:dir, '\c^[A-Z]:\\$') ==# 0)
      \ : (a:dir ==# s:FilePath.separator())
endfunction

""
" Returns a root directory.
"   a:dir - Base directory to search root directory.
"   a:000 - Root names. g#yacd#root_names will be used
"           if a:000 is not passed.
"
function! yacd#get_root_dir(dir, ...) abort
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

""
" Change local directory to root directory.
"
function! yacd#cd_to_root() abort
  if g:yacd#enable
    let fullpath = expand('%:p')
    if filereadable(fullpath)
      if exists('b:yacd_buf_dir') && exists('b:yacd_buf_root_dir')
        let cwd = getcwd()
        " Do not change directory if current directory is a root directory,
        " because I change current diretory to root directory temporarily for
        " quickrun.
        if cwd !=# b:yacd_buf_root_dir
          execute ':cd ' . fnameescape(b:yacd_buf_dir)
        endif
      else
        " At first time, change current directory to the directory that opening file is.
        let b:yacd_buf_dir = expand('%:p:h')
        let b:yacd_buf_root_dir = yacd#get_root_dir(b:yacd_buf_dir)
        execute ':cd ' . b:yacd_buf_dir
      endif
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
