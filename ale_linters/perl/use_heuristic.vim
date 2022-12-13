call ale#Set('use_heuristic_executable', 'python3')
call ale#Set('use_heuristic_path', expand('<sfile>:p:h') . '/perl-use-heuristics.py')

function ale_linters#perl#use_heuristic#Handle(buffer, lines) abort
    let l:output = []
    let l:pattern = '\v^(use of unused package .+) at \((\d+), (\d+)\)'

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \ 'lnum': str2nr(l:match[2]),
        \ 'lcol': str2nr(l:match[3]),
        \ 'type': 'W',
        \ 'text': l:match[1],
        \})
    endfor
    return l:output
endfunction


call ale#linter#Define('perl', {
\   'name': 'use-heuristic',
\   'executable': {b -> ale#Var(b, 'use_heuristic_executable')},
\   'command': {b -> '%e' . ale#Pad(ale#Var(b, 'use_heuristic_path')) . ' %t'},
\   'callback': 'ale_linters#perl#use_heuristic#Handle',
\})
