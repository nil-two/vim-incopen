if exists('g:loaded_incopen')
  finish
endif
let g:loaded_incopen = 1

command! -bar -range=1 Incopen
\ call incopen#incopen(<count>)
command! -bar -range=1 Decopen
\ call incopen#decopen(<count>)
command! -bar -range=1 Nextopen
\ call incopen#nextopen(<count>)
command! -bar -range=1 Prevopen
\ call incopen#prevopen(<count>)

nnoremap <silent> <Plug>(incopen)
\ :<C-u>call incopen#incopen(v:count ? v:count : 1)<CR>
nnoremap <silent> <Plug>(decopen)
\ :<C-u>call incopen#decopen(v:count ? v:count : 1)<CR>
nnoremap <silent> <Plug>(nextopen)
\ :<C-u>call incopen#nextopen(v:count ? v:count : 1)<CR>
nnoremap <silent> <Plug>(prevopen)
\ :<C-u>call incopen#prevopen(v:count ? v:count : 1)<CR>

let g:incopen_enable_wrap = get(g:, 'incopen_enable_wrap', 1)
