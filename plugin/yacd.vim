" Yet Another Changing Directory
" Version: 1.0
" Author: uochan <liquidz.uo@gmail.com>
" License: MIT LICENSE

if exists('g:loaded_unmanaged')
  finish
endif
let g:loaded_unmanaged = 1

let s:save_cpo = &cpo
set cpo&vim

augroup plugin-yacd
  autocmd!
  autocmd BufEnter * call yacd#cd_to_root()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
