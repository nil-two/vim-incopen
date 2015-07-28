" Open the incremented current path.
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

function! incopen#increment(expr, count)
  let width = strlen(a:expr)
  let num   = a:expr[matchend(a:expr, '^0*') :] + a:count
  return printf('%0'.width.'d', num)
endfunction

function! incopen#decrement(expr, count)
  if a:expr =~# '^0'
    let width  = strlen(a:expr)
    let orinum = a:expr[matchend(a:expr, '^0*') :] + 0
    let newnum = max([0, orinum - a:count])
    return printf('%0'.width.'d', newnum)
  endif
  let num = max([0, a:expr - a:count])
  return num
endfunction

function! incopen#genpath(fpath, count, calcfunc)
  let lastdigits = '\d\+\ze\D*$'
  if a:fpath !~# lastdigits
    return a:fpath
  endif
  let head = match(a:fpath, lastdigits)
  let tail = matchend(a:fpath, lastdigits)

  let lhs  = a:fpath[: head - 1]
  let expr = a:fpath[head : tail - 1]
  let rhs  = a:fpath[tail :]
  return lhs . a:calcfunc(expr, a:count) . rhs
endfunction

function! incopen#open(calcfunc, cnt)
  let path = expand('%:p')
  let nextpath = incopen#genpath(path, a:cnt, function(a:calcfunc))
  execute 'edit ' . nextpath
endfunction

function! incopen#incopen(...)
  call incopen#open('incopen#increment', get(a:, 1, 1))
endfunction

function! incopen#decopen(...)
  call incopen#open('incopen#decrement', get(a:, 1, 1))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
