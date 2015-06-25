let s:suite = themis#suite('genpath')
let s:assert = themis#helper('assert')

function! s:suite.test_increment()
  for test in [
  \ {'expr': '10', 'count': 1, 'dst': '11'},
  \ {'expr': '10', 'count': 2, 'dst': '12'},
  \
  \ {'expr': '010', 'count': 1, 'dst': '011'},
  \ {'expr': '010', 'count': 2, 'dst': '012'},
  \]
    let expect = test.dst
    let actual = incopen#increment(test.expr, test.count)
    call s:assert.equals(actual, expect)
  endfor
endfunction
