let s:suite = themis#suite('genpath')
let s:assert = themis#helper('assert')

function! s:suite.test_increment()
  for test in [
  \ {'expr': '10', 'count': 1, 'dst': '11'},
  \ {'expr': '10', 'count': 2, 'dst': '12'},
  \
  \ {'expr': '010', 'count': 1, 'dst': '011'},
  \ {'expr': '010', 'count': 2, 'dst': '012'},
  \
  \ {'expr': '010', 'count': 100,  'dst': '110'},
  \ {'expr': '010', 'count': 1000, 'dst': '1010'},
  \ {'expr': '002', 'count': 121,  'dst': '123'},
  \ {'expr': '002', 'count': 48,   'dst': '050'},
  \]
    let expect = test.dst
    let actual = incopen#increment(test.expr, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction

function! s:suite.test_decrement()
  for test in [
  \ {'expr': '10', 'count': 10, 'dst': '0'},
  \ {'expr': '10', 'count': 20, 'dst': '0'},
  \ 
  \ {'expr': '10',  'count': 1,  'dst': '9'},
  \ {'expr': '10',  'count': 2,  'dst': '8'},
  \ {'expr': '100', 'count': 95, 'dst': '5'},
  \
  \ {'expr': '0100', 'count': 100, 'dst': '0000'},
  \ {'expr': '0100', 'count': 200, 'dst': '0000'},
  \
  \ {'expr': '010',  'count': 1,   'dst': '009'},
  \ {'expr': '010',  'count': 2,   'dst': '008'},
  \ {'expr': '0101', 'count': 100, 'dst': '0001'},
  \ {'expr': '0500', 'count': 450, 'dst': '0050'},
  \]
    let expect = test.dst
    let actual = incopen#decrement(test.expr, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction

function! s:suite.test_genpath()
  for test in [
  \ {'expr': '/path/to/010.txt', 'count': 1, 'calcfunc': 'incopen#increment',
  \  'dst':  '/path/to/011.txt'},
  \ {'expr': '/path/to/010.txt', 'count': 5, 'calcfunc': 'incopen#increment',
  \  'dst':  '/path/to/015.txt'},
  \
  \ {'expr': '/path/to/010.txt', 'count': 1, 'calcfunc': 'incopen#decrement',
  \  'dst':  '/path/to/009.txt'},
  \ {'expr': '/path/to/010.txt', 'count': 5, 'calcfunc': 'incopen#decrement',
  \  'dst':  '/path/to/005.txt'},
  \ {'expr': '/path/to/010.txt', 'count': 15, 'calcfunc': 'incopen#decrement',
  \  'dst':  '/path/to/000.txt'},
  \]
    let expect = test.dst
    let actual = incopen#genpath(test.expr, test.count, function(test.calcfunc))
    call s:assert.equals(actual, expect)
  endfor
endfunction
