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
  let match    = match(a:expr, a:pat)
  let matchend = matchend(a:expr, a:pat)
  while 1
    let nextmatch = match(a:expr, a:pat, matchend+1)
    if nextmatch == -1
      break
    endif
    let match    = nextmatch
    let matchend = matchend(a:expr, a:pat, matchend+1)
  endwhile
  return match
endfunction

function! s:increment(expr, count)
  let headzero = matchstr(a:expr, '^0*')
  let num = a:expr[matchend(a:expr, '^0*') :]
  return headzero . (num + a:count)
endfunction

function! incopen#genpath(fpath, count, calcfunc)
  if a:fpath !~# '\d\+'
    return a:fpath
  endif
  let lastmatch    = s:lastmatch(a:fpath, '\d\+')
  let lastmatchend = matchend(a:fpath, '\d\+', lastmatch)

  let left  = a:fpath[: lastmatch - 1]
  let expr  = a:fpath[lastmatch : lastmatchend - 1]
  let right = a:fpath[lastmatchend :]
  return left . a:calcfunc(expr, a:count) . right
endfunction

function! incopen#open(fpath, count)
  let nextpath = incopen#genpath(a:fpath, a:count, function('s:increment'))
  execute 'edit ' . nextpath
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
