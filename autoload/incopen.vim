function! s:increment(expr, cnt) abort
  if a:expr =~# '^0'
    let fmt = '%0' . strlen(a:expr) . 'd'
    let orinum = a:expr[matchend(a:expr, '^0*') :] + 0
    let newnum = max([0, orinum + a:cnt])
    return printf(fmt, newnum)
  endif
  let num = max([0, a:expr + a:cnt])
  return num
endfunction

function! incopen#increment_path(fpath, cnt) abort
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

function! incopen#next_path(fpath, cnt) abort
  let rootpath = substitute(a:fpath, '[/\\]\zs[^/\\]*$', '', '')
  let pathes   = split(glob(rootpath . '*'), '\n')
  let files    = filter(pathes, '!isdirectory(v:val)')
  if len(files) < 1
    return a:fpath
  endif

  let idx = index(files, a:fpath) + a:cnt
  if g:incopen_enable_wrap
    return files[idx % len(files)]
  endif
  if idx < 0 || idx >= len(files)
    return a:fpath
  endif
  return files[idx]
endfunction

function! incopen#incopen(...) abort
  let cnt = get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#increment_path(fpath, cnt)
endfunction

function! incopen#decopen(...) abort
  let cnt = 0 - get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#increment_path(fpath, cnt)
endfunction

function! incopen#nextopen(...) abort
  let cnt = get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#next_path(fpath, cnt)
endfunction

function! incopen#prevopen(...) abort
  let cnt = 0 - get(a:, 1, 1)
  let fpath = expand('%:p')
  execute 'edit ' . incopen#next_path(fpath, cnt)
endfunction
