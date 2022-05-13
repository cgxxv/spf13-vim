" setup boilerplate to make this file usable with vim -Nu <tihs file> {{{
set noequalalways
" }}}

" Custom Layout {{{

function! s:CustomiseUI()
  let wins = g:vimspector_session_windows

  " Close the Variables window
  if has( 'nvim' )
    " No win_execute in neovim
    call win_gotoid( wins.variables )
    quit
  else
    call win_execute( wins.variables, 'q' )
  endif

  " Put the stack trace at the top of the "left bar" (rotate)
  call win_gotoid( wins.stack_trace )
  wincmd r

  " Make the left column at least 70 chars
  70wincmd |

  " Make the code window at least 80 chars
  call win_gotoid( wins.code )
  80wincmd |

  " Make the output window 10 lines high and right at the top of the screen
  call win_gotoid( wins.output )
  5wincmd _
  wincmd K

  " Enable keyboard-hover for vars and watches
  call win_gotoid( g:vimspector_session_windows.variables )
  " for normal mode - the word under the cursor
  nmap <silent> <buffer> <Leader>di <Plug>VimspectorBalloonEval

  call win_gotoid( g:vimspector_session_windows.watches )
  " for visual mode, the visually selected text
  xmap <silent> <buffer> <Leader>di <Plug>VimspectorBalloonEval
endfunction

function s:SetUpTerminal()
  if !has_key( g:vimspector_session_windows, 'terminal' )
    " There's a neovim bug which means that this doesn't work in neovim
    return
  endif
  let terminal_win = g:vimspector_session_windows.terminal

  " Make the terminal window at most 80 columns wide, ensuring there is enough
  " sapce for our code window (80 columns) and the left bar (70 columns)

  " Padding is 2 for the 2 vertical split markers and 2 for the sign column in
  " the code window.
  let left_bar = 60
  let code = 80
  let padding = 4
  let cols = max( [ min( [ &columns - left_bar - code - padding, 80 ] ), 10 ] )
  call win_gotoid( terminal_win )
  execute string(cols) . 'wincmd |'
endfunction

function! s:CustomiseWinBar()
    call win_gotoid( g:vimspector_session_windows.code)
    aunmenu WinBar
    nnoremenu WinBar.▷\F5 :call vimspector#Continue()<CR>
    nnoremenu WinBar.❘❘\F6 :call vimspector#Pause()<CR>
    nnoremenu WinBar.↷\F10 :call vimspector#StepOver()<CR>
    nnoremenu WinBar.↓\F11 :call vimspector#StepInto()<CR>
    nnoremenu WinBar.↑\F12 :call vimspector#StepOut()<CR>
    nnoremenu WinBar.⟲\F4 :call vimspector#Restart()<CR>
    nnoremenu WinBar.□\F3 :call vimspector#Stop()<CR>
    nnoremenu WinBar.✕\F7 :call vimspector#Reset()<CR>
endfunction

augroup TestUICustomistaion
    autocmd!
    autocmd User VimspectorUICreated call s:CustomiseUI()
    autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
    if !has('nvim')
        autocmd User VimspectorUICreated call s:CustomiseWinBar()
    endif
augroup END

" }}}

" Custom sign priority {{{

let g:vimspector_sign_priority = {
  \    'vimspectorBP':         3,
  \    'vimspectorBPCond':     2,
  \    'vimspectorBPDisabled': 1,
  \    'vimspectorPC':         999,
  \ }

" }}}

" Custom mappings while debuggins {{{
let s:mapped = {}

function! s:OnJumpToFrame() abort
  if has_key( s:mapped, string( bufnr() ) )
    return
  endif

  nmap <silent> <buffer> <Leader>dn <Plug>VimspectorStepOver
  nmap <silent> <buffer> <Leader>ds <Plug>VimspectorStepInto
  nmap <silent> <buffer> <Leader>df <Plug>VimspectorStepOut
  nmap <silent> <buffer> <Leader>dc <Plug>VimspectorContinue
  nmap <silent> <buffer> <Leader>di <Plug>VimspectorBalloonEval
  xmap <silent> <buffer> <Leader>di <Plug>VimspectorBalloonEval

  let s:mapped[ string( bufnr() ) ] = { 'modifiable': &modifiable }

  setlocal nomodifiable

endfunction

function! s:OnDebugEnd() abort

  let original_buf = bufnr()
  let hidden = &hidden
  augroup VimspectorSwapExists
    au!
    autocmd SwapExists * let v:swapchoice='o'
  augroup END

  try
    set hidden
    for bufnr in keys( s:mapped )
      try
        execute 'buffer' bufnr
        silent! nunmap <buffer> <Leader>dn
        silent! nunmap <buffer> <Leader>ds
        silent! nunmap <buffer> <Leader>df
        silent! nunmap <buffer> <Leader>dc
        silent! nunmap <buffer> <Leader>di
        silent! xunmap <buffer> <Leader>di

        let &l:modifiable = s:mapped[ bufnr ][ 'modifiable' ]
      endtry
    endfor
  finally
    execute 'noautocmd buffer' original_buf
    let &hidden = hidden
  endtry

  au! VimspectorSwapExists

  let s:mapped = {}
endfunction

augroup TestCustomMappings
  au!
  autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
  autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
augroup END

" }}}

" Custom mappings for special buffers {{{

let g:vimspector_mappings = {
      \   'stack_trace': {},
      \   'variables': {
      \    'set_value': [ '<Tab>', '<C-CR>', 'C' ],
      \   }
      \ }

" }}}

" vim: foldmethod=marker
