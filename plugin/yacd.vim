if exists('g:loaded_yacd')
  finish
endif
let g:loaded_yacd = 1

let s:save_cpo = &cpo
set cpo&vim

augroup plugin-yacd
  autocmd!
  autocmd BufEnter * call yacd#cd_to_root()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
