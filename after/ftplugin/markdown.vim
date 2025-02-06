setlocal wrap

function! HighlightKeywords()
    call clearmatches()
    
    call matchadd('TaskHL', '\<TASK\>')
    call matchadd('DoneHL', '\<DONE\>')
    call matchadd('ActiveHL', '\<ACTIVE\>')
endfunction

call HighlightKeywords()
