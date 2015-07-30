" Open the incremented current path.
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

function! s:increment(expr, count)
  if a:expr =~# '^0'
    let width  = strlen(a:expr)
    let orinum = a:expr[matchend(a:expr, '^0*') :] + 0
    let newnum = max([0, orinum + a:count])
    return printf('%0'.width.'d', newnum)
  endif
  let num = max([0, a:expr + a:count])
  return num
endfunction

function! incopen#increment_path(fpath, count)
  let lastdigits = '\d\+\ze\D*$'
  if a:fpath !~# lastdigits
    return a:fpath
  endif
  let len  = strlen(a:fpath)
  let head = match(a:fpath, lastdigits)
  let tail = matchend(a:fpath, lastdigits)

  let lhs  = strpart(a:fpath, 0,    head)
  let expr = strpart(a:fpath, head, tail - head)
  let rhs  = strpart(a:fpath, tail, len  - tail)
  return lhs . s:increment(expr, a:count) . rhs
endfunction

function! incopen#open(count)
  let path = expand('%:p')
  let nextpath = incopen#increment_path(path, a:count)
  execute 'edit ' . nextpath
endfunction

function! incopen#incopen(...)
  call incopen#open(get(a:, 1, 1))
endfunction

function! incopen#decopen(...)
  call incopen#open(-get(a:, 1, 1))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
