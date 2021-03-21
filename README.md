incopen
=======

![CI](https://github.com/kusabashira/vim-incopen/workflows/CI/badge.svg)

Open the incremented path.

It's inspired by
[vimperator](https://addons.mozilla.org/ja/firefox/addon/vimperator/)'s
`<C-a>` and `<C-x>`.

Usage
-----

#### Open file

```
:Incopen
```

If your path is `/path/to/010.txt`,
it will open `/path/to/011.txt`.

#### With count

```
:5Incopen
```

If your path is `/path/to/010.txt`,
it will open `/path/to/015.txt`.

Example of `vimrc`
------------------

```vim
" Open incremented path.
nmap <silent>)) <Plug>(incopen)

" Open decrmented path.
nmap <silent>(( <Plug>(decopen)
```

License
-------

MIT License

Author
------

kusabashira <kusabashira227@gmail.com>
