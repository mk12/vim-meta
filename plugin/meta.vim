" meta.vim - Meta mappings
" Maintainer:   Mitchell Kember
" Version:      1.0

if exists("g:loaded_meta") || v:version < 700 || &cp
    finish
endif
let g:loaded_meta = 1

noremap <C-A> <Home>
noremap! <C-A> <Home>
noremap <C-E> <End>
noremap! <C-E> <End>

inoremap <expr> <C-K> col('.') is col('$') ? '' : '<C-O>D'
cnoremap <C-K> <C-\>e getcmdpos() is 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

nnoremap <C-S-K> dd
xnoremap <C-S-K> d
inoremap <C-S-K> <C-O>dd

noremap! <expr> <C-T> <SID>TransposeCharsExpr()
inoremap <M-t> <Space><Left><Esc>wgediw"_xbPa<Space><C-O>w<C-O>ge<Right><Del>
inoremap <M-T> <Space><Left><Esc>WgEdiW"_xBPa<Space><C-O>W<C-O>gE<Right><Del>
" TODO: Rewrite these using cmdline directly.
cmap <M-t> <C-F>i<M-t><C-c>
cmap <M-T> <C-F>i<M-T><C-c>

" New mapping for <C-T> indent.
inoremap <C-F> <C-T>

noremap <M-Left> b
inoremap <M-Left> <C-O>b
cnoremap <M-Left> <C-\>e <SID>CmdlineNavigate('b')<CR>

noremap <expr> <M-Right> <SID>NormalNavigateExpr('e')
inoremap <expr> <M-Right> <SID>InsertNavigateExpr('e')
cnoremap <M-Right> <C-\>e <SID>CmdlineNavigate('e')<CR>

noremap <M-S-Left> B
inoremap <M-S-Left> <C-O>B
" We could just use <C-Left>, but it doesn't skip over multiple spaces.
cnoremap <M-S-Left> <C-\>e <SID>CmdlineNavigate('B')<CR>

noremap <expr> <M-S-Right> <SID>NormalNavigateExpr('E')
inoremap <expr> <M-S-Right> <SID>InsertNavigateExpr('E')
" We could just use <C-Right>, but it doesn't skip over multiple spaces.
cnoremap <M-S-Right> <C-\>e <SID>CmdlineNavigate('E')<CR>

noremap! <M-BS> <C-W>

inoremap <M-Del> <C-O>de
cnoremap <M-Del> <C-\>e <SID>CmdlineDelete('e')<CR>

" Vim can't detect <M-S-BS> so we rely on the user to configure their terminal
" to convert it to <M-B> if desired. For example, in kitty config:
"
"     map shift+alt+backspace send_text all \x1bB
"
inoremap <expr> <M-B> col('.') is col('$') ? 'x<C-O>dB<BS>' : '<C-O>dB'
cnoremap <M-B> <C-\>e <SID>CmdlineDelete('B')<CR>

inoremap <M-S-Del> <C-O>dE
cnoremap <M-S-Del> <C-\>e <SID>CmdlineDelete('E')<CR>

" New mapping for <C-A> increase number.
nnoremap <M-x> <C-A>

" New mapping for <C-E> scroll down.
nnoremap <C-H> <C-E>

" VS Code style bindings.
nmap <M-Up> [e
xmap <M-Up> [egv
imap <M-Up> <C-O>[e
nmap <M-Down> ]e
xmap <M-Down> ]egv
imap <M-Down> <C-O>]e
nnoremap <M-S-Up> yyP
nnoremap <M-S-Down> yyp
xnoremap <M-S-Up> y`>pgv
xnoremap <M-S-Down> yPgv
inoremap <M-S-Up> <C-O>yy<C-O>P
inoremap <M-S-Down> <C-O>yy<C-O>p

function! s:TransposeCharsExpr() abort
    let l:cmd = mode() == 'c'
    let l:col = l:cmd ? getcmdpos() : col('.')
    let l:line = l:cmd ? getcmdline() : getline('.')
    if l:col <= 2
        return ''
    endif
    return "\<BS>\<BS>" . l:line[l:col-2] . l:line[l:col-3]
endfunction

function! s:NormalNavigateExpr(e) abort
    let l:col = col('.')
    let l:last = col('$') - 1
    " This special case is necessary when on a single-letter word at the start
    " of the line. Otherwise, it will skip to the end of the _next_ word.
    if l:col == 1 && l:col < l:last && match(getline('.'), '^\s') is -1
        let l:w = a:e is# 'e' ? 'w' : 'W'
        return l:w . "g" . a:e . "\<Right>"
    endif
    " This special case is necessary (1) at the start since you can't move left;
    " (2) at the end, because the last movement lands you _on_ the last
    " character rather than just past it, so <Left>e<Right> would be a no-op.
    if l:col == 1 || l:col == l:last
        return a:e . "\<Right>"
    endif
    return "\<Left>" . a:e . "\<Right>"
endfunction

function! s:InsertNavigateExpr(e) abort
    let l:col = col('.')
    let l:last = col('$') - 1
    " This special case is necessary when on a single-letter word at the start
    " of the line. Otherwise, it will skip to the end of the _next_ word.
    if l:col == 1 && l:col < l:last && match(getline('.'), '^\s') is -1
        let l:w = a:e is# 'e' ? 'w' : 'W'
        return "\<C-O>" . l:w . "\<C-O>g" . a:e . "\<Right>"
    endif
    " This special case is necessary at the start since you can't move left.
    " (Or even if it does work, it causes the bell to ring which is annoying.)
    if l:col == 1
        return "\<C-O>" . a:e . "\<Right>"
    endif
    return "\<Left>\<C-O>" . a:e . "\<Right>"
endfunction

function! s:CmdlineNavigate(char) abort
    call setcmdpos(s:CmdlineIndex(a:char))
    return getcmdline()
endfunction

function! s:CmdlineDelete(char) abort
    let l:cmd = getcmdline()
    let l:i = getcmdpos() - 1
    let l:j = s:CmdlineIndex(a:char) - 1
    if a:char is? 'B'
        call setcmdpos(l:j + 1)
        return (l:j is 0 ? '' : l:cmd[:l:j-1]) . l:cmd[l:i:]
    endif
    if a:char is? 'E'
        return (l:i is 0 ? '' : l:cmd[:l:i-1]) . l:cmd[l:j:]
    endif
endfunction

function! s:CmdlineIndex(char) abort
    let l:cmd = getcmdline()
    if a:char is? 'B'
        let l:i = getcmdpos() - 1
        while l:i > 0
            let l:i = l:i - 1
            if match(l:cmd[l:i], '\s') is -1
                break
            endif
        endwhile
        if a:char is# 'B'
            while l:i > 0 && match(l:cmd[l:i - 1], '\s') is -1
                let l:i = l:i - 1
            endwhile
        else
            if match(l:cmd[l:i], '\k') isnot -1
                while l:i > 0 && match(l:cmd[l:i - 1], '\k') isnot -1
                    let l:i = l:i - 1
                endwhile
            else
                while l:i > 0 && match(l:cmd[l:i - 1], '\k\|\s') is -1
                    let l:i = l:i - 1
                endwhile
            endif
        endif
    elseif a:char is? 'E'
        let l:i = getcmdpos() - 1
        let l:max = len(l:cmd) - 1
        while l:i < l:max && match(l:cmd[l:i], '\s') isnot -1
            let l:i = l:i + 1
        endwhile
        if a:char is# 'E'
            while l:i < l:max + 1
                let l:i = l:i + 1
                if l:i == l:max + 1 || match(l:cmd[l:i], '\s') isnot -1
                    break
                endif
            endwhile
        else
            if match(l:cmd[l:i], '\k') isnot -1
                while l:i <= l:max
                    let l:i = l:i + 1
                    if l:i == l:max + 1 || match(l:cmd[l:i], '\k') is -1
                        break
                    endif
                endwhile
            else
                while l:i <= l:max
                    let l:i = l:i + 1
                    if l:i == l:max + 1 || match(l:cmd[l:i], '\k\|\s') isnot -1
                        break
                    endif
                endwhile
            endif
        endif
    else
        call s:Error("Invalid CmdlineIndex arg: " . a:char)
    end
    return l:i + 1
endfunction

" vim:set et sw=4:
