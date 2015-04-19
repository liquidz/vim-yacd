let s:suite  = themis#suite('vim-yacd test')
let s:assert = themis#helper('assert')

let s:V = vital#of('yacd')
let s:FilePath = s:V.import('System.Filepath')

function! s:suite.get_root_dir_test() abort
  let root_dir = getcwd()
  let test_dir = s:FilePath.join(root_dir, 'test')
  call s:assert.equals(
      \ yacd#get_root_dir(test_dir),
      \ root_dir)
endfunction

function! s:suite.get_root_dir_test_with_custom_root_names() abort
  let test_dir = s:FilePath.join(getcwd(), 'test')
  call s:assert.equals(
      \ yacd#get_root_dir(test_dir, ['suite.vim']),
      \ test_dir)
endfunction
