" Open the incremented current path.
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

function! s:increment(expr, cnt)
  if a:expr =~# '^0'
    let width  = strlen(a:expr)
    let orinum = a:expr[matchend(a:expr, '^0*') :] + 0
    let newnum = max([0, orinum + a:cnt])
    return printf('%0'.width.'d', newnum)
  endif
  let num = max([0, a:expr + a:cnt])
  return num
endfunction

function! incopen#increment_path(fpath, cnt)
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
  return lhs . s:increment(expr, a:cnt) . rhs
endfunction

function! incopen#next_path(fpath, cnt)
  let rootpath = substitute(a:fpath, '[/\\]\zs[^/\\]*$', '', '')
  let pathes   = split(glob(rootpath . '*'), '\n')
  let files    = filter(pathes, '!isdirectory(v:val)')
  if len(files) < 1
    return a:fpath
  endif

  let idx = index(files, a:fpath) + a:cnt
  if idx < 0 || idx >= len(files)
    return a:fpath
  endif
  return files[idx]
endfunction

function! incopen#incopen(...)
  let cnt = get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#increment_path(fpath, cnt)
endfunction

function! incopen#decopen(...)
  let cnt = 0 - get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#increment_path(fpath, cnt)
endfunction

function! incopen#nextopen(...)
  let cnt = get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#next_path(fpath, cnt)
endfunction

function! incopen#prevopen(...)
  let cnt = 0 - get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#next_path(fpath, cnt)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
