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
  let l:match    = match(a:expr, a:pat)
  let l:matchend = matchend(a:expr, a:pat)
  while 1
    let l:nextmatch = match(a:expr, a:pat, l:matchend+1)
    if l:nextmatch == -1
      break
    endif
    let l:match    = l:nextmatch
    let l:matchend = matchend(a:expr, a:pat, l:matchend+1)
  endwhile
  return l:match
endfunction

function! s:increment(expr, count)
  let l:headzero = matchstr(a:expr, '^0*')
  let l:num = a:expr[matchend(a:expr, '^0*') :]
  return l:headzero . (l:num + a:count)
endfunction

function! incopen#increment(fpath, count)
  if a:fpath !~# '\d\+'
    return a:fpath
  endif
  let l:lastmatch    = s:lastmatch(a:fpath, '\d\+')
  let l:lastmatchend = matchend(a:fpath, '\d\+', l:lastmatch)

  let l:left  = a:fpath[: l:lastmatch - 1]
  let l:expr  = a:fpath[l:lastmatch : l:lastmatchend - 1]
  let l:right = a:fpath[l:lastmatchend :]
  return l:left . s:increment(l:expr, a:count) . l:right
endfunction

function! incopen#open(fpath, count)
  let l:nextpath = incopen#increment(a:fpath, a:count)
  execute 'edit ' . l:nextpath
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
