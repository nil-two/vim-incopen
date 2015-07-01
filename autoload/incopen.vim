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
  let lenhead  = strlen(headzero)

  let orinum  = a:expr[lenhead :] + 0
  let newnum  = orinum + a:count
  let lendiff = strlen(string(newnum)) - strlen(string(orinum))
  if orinum == 0
    let lendiff += 1
  end

  if lendiff >= lenhead
    let headzero = ''
  elseif lendiff > 0
    let headzero = headzero[: lenhead - lendiff - 1]
  endif
  return headzero . newnum
endfunction

function! incopen#decrement(expr, count)
  let headzero = matchstr(a:expr, '^0*')
  let lenhead  = strlen(headzero)

  let orinum = a:expr[matchend(a:expr, '^0*') :] + 0
  if orinum == 0
    return a:expr
  endif
  let newnum = orinum - a:count
  if newnum < 0
    let newnum = 0
  endif
  let lendiff = strlen(string(orinum)) - strlen(string(newnum))

  if lenhead > 0 && lendiff > 0
    let headzero = headzero . repeat('0', lendiff)
  endif
  return headzero . newnum
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
