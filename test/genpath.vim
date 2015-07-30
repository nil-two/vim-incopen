let s:suite = themis#suite('genpath')
let s:assert = themis#helper('assert')

function! s:suite.test_increment()
  for test in [
  \   {'fpath': '0',   'count': 1, 'dst': '1'},
  \   {'fpath': '00',  'count': 1, 'dst': '01'},
  \   {'fpath': '000', 'count': 1, 'dst': '001'},
  \
  \   {'fpath': '10', 'count': 1, 'dst': '11'},
  \   {'fpath': '10', 'count': 2, 'dst': '12'},
  \
  \   {'fpath': '010', 'count': 1, 'dst': '011'},
  \   {'fpath': '010', 'count': 2, 'dst': '012'},
  \
  \   {'fpath': '010', 'count': 100,  'dst': '110'},
  \   {'fpath': '010', 'count': 1000, 'dst': '1010'},
  \   {'fpath': '002', 'count': 121,  'dst': '123'},
  \   {'fpath': '002', 'count': 48,   'dst': '050'},
  \ ]
    let expect = test.dst
    let actual = incopen#increment_path(test.fpath, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction

function! s:suite.test_decrement()
  for test in [
  \   {'fpath': '0',   'count': -1, 'dst': '0'},
  \   {'fpath': '00',  'count': -1, 'dst': '00'},
  \   {'fpath': '000', 'count': -1, 'dst': '000'},
  \
  \   {'fpath': '10', 'count': -10, 'dst': '0'},
  \   {'fpath': '10', 'count': -20, 'dst': '0'},
  \   
  \   {'fpath': '10',  'count': -1,  'dst': '9'},
  \   {'fpath': '10',  'count': -2,  'dst': '8'},
  \   {'fpath': '100', 'count': -95, 'dst': '5'},
  \
  \   {'fpath': '0100', 'count': -100, 'dst': '0000'},
  \   {'fpath': '0100', 'count': -200, 'dst': '0000'},
  \
  \   {'fpath': '010',  'count': -1,   'dst': '009'},
  \   {'fpath': '010',  'count': -2,   'dst': '008'},
  \   {'fpath': '0101', 'count': -100, 'dst': '0001'},
  \   {'fpath': '0500', 'count': -450, 'dst': '0050'},
  \ ]
    let expect = test.dst
    let actual = incopen#increment_path(test.fpath, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction

function! s:suite.test_increment_path()
  for test in [
  \   {'fpath': '/path/to/010.txt', 'count': 1,
  \    'dst':   '/path/to/011.txt'},
  \   {'fpath': '/path/to/010.txt', 'count': 5,
  \    'dst':   '/path/to/015.txt'},
  \
  \   {'fpath': '/path/to/010.txt', 'count': -1,
  \    'dst':   '/path/to/009.txt'},
  \   {'fpath': '/path/to/010.txt', 'count': -5,
  \    'dst':   '/path/to/005.txt'},
  \   {'fpath': '/path/to/010.txt', 'count': -15,
  \    'dst':   '/path/to/000.txt'},
  \
  \   {'fpath': '/10/20/010.txt', 'count': 1,
  \    'dst':   '/10/20/011.txt'},
  \   {'fpath': '/10/20/010.txt', 'count': 5,
  \    'dst':   '/10/20/015.txt'},
  \
  \   {'fpath': '/path/01/idx.txt', 'count': 1,
  \    'dst':   '/path/02/idx.txt'},
  \   {'fpath': '/path/01/idx.txt', 'count': 5,
  \    'dst':   '/path/06/idx.txt'},
  \
  \   {'fpath': '/path/to', 'count': 1,
  \    'dst':   '/path/to'},
  \   {'fpath': '/path/to/recipe.txt', 'count': 1,
  \    'dst':   '/path/to/recipe.txt'},
  \ ]
    let expect = test.dst
    let actual = incopen#increment_path(test.fpath, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction
