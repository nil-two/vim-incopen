" Open the incremented current path.
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

function! s:lastmatch(expr, pat)
  if a:expr !~# a:pat
    return -1
  endif
  let head = match(a:expr, a:pat)
  let tail = matchend(a:expr, a:pat)
  while 1
    let nexthead = match(a:expr, a:pat, tail+1)
    if nexthead == -1
      break
    endif
    let head = nexthead
    let tail = matchend(a:expr, a:pat, tail+1)
  endwhile
  return head
endfunction

function! incopen#increment(expr, count)
  let headzero = matchstr(a:expr, '^0*')
  let num = a:expr[matchend(a:expr, '^0*') :]
  return headzero . (num + a:count)
endfunction

function! incopen#decrement(expr, count)
  let headzero = matchstr(a:expr, '^0*')
  let num = a:expr[matchend(a:expr, '^0*') :]
  if (num - a:count) < 0
    return headzero . a:count
  endif
  return headzero . (num - a:count)
endfunction

function! incopen#genpath(fpath, count, calcfunc)
  if a:fpath !~# '\d\+'
    return a:fpath
  endif
  let head = s:lastmatch(a:fpath, '\d\+')
  let tail = matchend(a:fpath, '\d\+', head)

  let lhs  = a:fpath[: head - 1]
  let expr = a:fpath[head : tail - 1]
  let rhs  = a:fpath[tail :]
  return lhs . a:calcfunc(expr, a:count) . rhs
endfunction

function! incopen#incopen(fpath, count)
  let nextpath = incopen#genpath(a:fpath, a:count, function('incopen#increment'))
  execute 'edit ' . nextpath
endfunction

function! incopen#decopen(fpath, count)
  let nextpath = incopen#genpath(a:fpath, a:count, function('incopen#decrement'))
  execute 'edit ' . nextpath
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
