if !exists('g:vscode')
" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"                    __ _ _____              _
"         ___ _ __  / _/ |___ /      __   __(_)_ __ ___
"        / __| '_ \| |_| | |_ \ _____\ \ / /| | '_ ` _ \
"        \__ \ |_) |  _| |___) |_____|\ V / | | | | | | |
"        |___/ .__/|_| |_|____/        \_/  |_|_| |_| |_|
"            |_|
"
"   This is the personal .vimrc file of Steve Francia.
"   While much of it is beneficial for general use, I would
"   recommend picking out the parts you want and understand.
"
"   You can find me at http://spf13.com
"
"   Copyright 2014 Steve Francia
"
"   Licensed under the Apache License, Version 2.0 (the "License");
"   you may not use this file except in compliance with the License.
"   You may obtain a copy of the License at
"
"       http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"   See the License for the specific language governing permissions and
"   limitations under the License.
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        set showcmd
        if !WINDOWS()
            set shell=$SHELL
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {

    set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator
    set errorbells                      " Trigger bell on error


    set nobackup                        " Some servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/649.
    set nowritebackup
    " set cmdheight=2                     " Give more space for displaying messages.
    set shortmess+=c                    " Don't pass messages to |ins-completion-menu|.

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    if has('vim_starting')
        set encoding=utf-8
        scriptencoding utf-8
    endif

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }
" }

" Vim UI {
    " theme section{
    source ~/.vim/theme.vim
    " }

    " minimap section {
    ""if isdirectory(expand("~/.vim/bundle/minimap.vim/"))
    ""   let g:minimap_width = 10
    ""   let g:minimap_auto_start = 1
    ""   let g:minimap_auto_start_win_enter = 1
    ""   let g:minimap_highlight_range = 1
    ""   let g:minimap_highlight_search = 1
    ""   let g:minimap_block_filetypes = ['fugitive', 'nerdtree', 'tagbar', 'defx.nvim' ]

    ""   "hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
    ""   "let g:minimap_highlight = 'MinimapCurrentLine'

    ""   nnoremap <silent> `` :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>
    ""endif
    " }

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    "set foldenable                  " Auto fold code
    set nofoldenable                " Disable fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

    " autocmd BufWritePre * :%s/\s\+$//e
" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:spf13_leader='\'
    if !exists('g:spf13_leader')
        let mapleader = ','
    else
        let mapleader=g:spf13_leader
    endif
    if !exists('g:spf13_localleader')
        let maplocalleader = '_'
    else
        let maplocalleader=g:spf13_localleader
    endif

    " The default mappings for editing and applying the spf13 configuration
    " are <leader>ev and <leader>sv respectively. Change them to your preference
    " by adding the following to your .vimrc.before.local file:
    "   let g:spf13_edit_config_mapping='<leader>ec'
    "   let g:spf13_apply_config_mapping='<leader>sc'
    if !exists('g:spf13_edit_config_mapping')
        let s:spf13_edit_config_mapping = '<leader>ev'
    else
        let s:spf13_edit_config_mapping = g:spf13_edit_config_mapping
    endif
    if !exists('g:spf13_apply_config_mapping')
        let s:spf13_apply_config_mapping = '<leader>sv'
    else
        let s:spf13_apply_config_mapping = g:spf13_apply_config_mapping
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_easyWindows = 1
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_wrapRelMotion = 1
    if !exists('g:spf13_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    "" FIXME
    "" Support Meta key mapping
    "" iterm2 on mac is ok
    "" https://unix.stackexchange.com/questions/14765/how-to-map-alt-key-in-vimrc
    "for i in range(65,90)
    "    " bind M-S-a..z (M-A..Z)
    "    let C = nr2char(i)
    "    exec "map \e".C." <M-".C.">"
    "    exec "map! \e".C." <M-".C.">"

    "    " bind M-a..z
    "    let c = nr2char(i+32)
    "    exec "map \e".c." <M-".c.">"
    "    exec "map! \e".c." <M-".c.">"
    "endfor

    " Fast buffer switching.
    " If you doesn't like the key-bindings, add the following to your
    " .vimrc.before.local file:
    " let g:spf13_no_fastBuffers = 1
    if !exists('g:spf13_no_fastBuffers')
        exec "map \eH <M-H>"
        exec "map \eL <M-L>"
        exec "map! \eH <M-H>"
        exec "map! \eL <M-L>"
        nnoremap <M-H> :bprev<CR>
        nnoremap <M-L> :bnext<CR>
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>l0 :set foldlevel=0<CR>
    nmap <leader>l1 :set foldlevel=1<CR>
    nmap <leader>l2 :set foldlevel=2<CR>
    nmap <leader>l3 :set foldlevel=3<CR>
    nmap <leader>l4 :set foldlevel=4<CR>
    nmap <leader>l5 :set foldlevel=5<CR>
    nmap <leader>l6 :set foldlevel=6<CR>
    nmap <leader>l7 :set foldlevel=7<CR>
    nmap <leader>l8 :set foldlevel=8<CR>
    nmap <leader>l9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:spf13_clear_search_highlight = 1
    if exists('g:spf13_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

    " FIXME
    " Alt key bindings
    " https://unix.stackexchange.com/questions/49203/vim-customized-with-emacs-commands-insert-mode-only
    " https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
    " https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
    " https://unix.stackexchange.com/questions/14765/how-to-map-alt-key-in-vimrc
    " https://www.reddit.com/r/vim/comments/4w0lib/do_you_use_insert_mode_keybindings/
    " https://vi.stackexchange.com/questions/7722/how-to-debug-a-mapping
    " https://stackoverflow.com/questions/2483849/detect-if-a-key-is-bound-to-something-in-vim
    " https://stackoverflow.com/questions/8750275/vim-super-fast-navigation
    " https://medium.com/usevim/vim-101-quick-movement-c12889e759e0#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlZGMwMTJkMDdmNTJhZWRmZDVmOTc3ODRlMWJjYmUyM2MxOTcyNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2MDU5NjI5NjYsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNzUxMjA0Nzk1NTQ1ODExODYxOSIsImVtYWlsIjoiZm9vc3RhY2tlci56enFAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJrIHciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2oyVnc4bWxCU1pqMzh4MDVQckt4eVZDekljQUNtUEtQdEtlTEFtM1E9czk2LWMiLCJnaXZlbl9uYW1lIjoiayIsImZhbWlseV9uYW1lIjoidyIsImlhdCI6MTYwNTk2MzI2NiwiZXhwIjoxNjA1OTY2ODY2LCJqdGkiOiIyYjA3MGNkN2VmY2MyZTRmODVhY2MyMWE1N2Y5N2Y3YTFjYjIwY2FmIn0.hDgzsW-ALIZZELzh7y5ggy-OqVMS7DM_X5TtuIO8T-JorPnnZbyZ3VgDRraxBaIs5WL2fXwSXIYZyyxC1RqZAAT8vRpY8sQAVui-zeJj2s6Xl3c1tvU9lBH4GXstGgxVuFR1b8DdND_tnzzZV5Q-GUtwJ4R-NgHzgk1fj8DSQGw7Fl4_-ZuYN65brNWOJhE23tGudjnpQp5KYO8B4Irh6x-e5YLBTSGYbwYZK62MLdBPiSuf7NW1ZZZHTWI_LQWxDidD54Ha9ayeqHfnKn_SsA4wPewAVe9MjgXEtaQP09pVrmq_X3AXfPOK1ZxVxHvPcNr1Qy8l0FE8olE5qgOPRw
    " Mimic Emacs Line Editing in Insert Mode Only
    " movement
    "inoremap <C-A> <Home>
    "inoremap <C-E> <End>
    "inoremap <C-F> <Right>
    "inoremap <C-B> <Left>
    "" buffer
    "inoremap <C-U> <Esc>d0xi
    "inoremap <C-Y> <Esc>Pa
    "inoremap <C-X><C-E> <Esc>Da
    "inoremap <C-X><C-S> <Esc>:w<CR>i
    "inoremap <C-X><C-X> <Esc>ddi

    "quickrun
    if isdirectory(expand("~/.vim/bundle/vim-quickrun"))
        noremap <Leader>q :QuickRun<CR>
    endif

    "vim debugging with vimspector
    if isdirectory(expand("~/.vim/bundle/vimspector"))
        function! s:spf13_vimspector_winbar()
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

        augroup spf13_vim_ui_customistaion
            autocmd!
            if !has('nvim')
                autocmd User VimspectorUICreated call s:spf13_vimspector_winbar()
            endif
        augroup END

        let g:vimspector_enable_mappings = 'HUMAN'
        let g:vimspector_sidebar_width = 75
        let g:vimspector_bottombar_height = 15
        let g:vimspector_code_minwidth = 90
        let g:vimspector_terminal_maxwidth = 75
        let g:vimspector_terminal_minwidth = 20
        noremap <silent> <F7> :VimspectorReset<CR>
    endif
" }

" Coc.nvim {
    if count(g:spf13_bundle_groups, 'coc')
        " Specify your node path in .vimrc.before.local
        " let g:coc_node_path = '/usr/local/bin/node'
        if !exists('g:coc_node_path')
            let g:coc_node_path = trim(system('which node'))
        endif

        " Custom you coc extensions in .vimrc.before.local
        " let g:coc_global_extensions = []
        if !exists('g:coc_global_extension')
            let g:coc_global_extensions = [
                \ 'coc-json', 'coc-highlight', 'coc-snippets', 'coc-emmet',
                \ 'coc-tabnine',
                \ 'coc-tsserver', 'coc-html', 'coc-css', 'coc-vetur',
                \ 'coc-sql', 'coc-sh', 'coc-markdownlint',
                \ 'coc-vimlsp', 'coc-phpls', 'coc-pyright',
                \ 'coc-clangd', 'coc-cmake',
                \ 'coc-go',
                \ 'coc-rust-analyzer',
                \ ]
        endif

        source ~/.vim/coc.vim
    endif
" }

" Plugins {

    " vim-startify {
        if isdirectory(expand("~/.vim/bundle/vim-startify"))
            "let g:startify_enable_special = 0
        endif
    " }

    " easymotion {
        if isdirectory(expand("~/.vim/bundle/vim-easymotion"))
			 " type `l` and match `l`&`L`
			let g:EasyMotion_smartcase = 1
			" Smartsign (type `3` and match `3`&`#`)
			let g:EasyMotion_use_smartsign_us = 1
			let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

            " JK motions: Line motions
			map <Leader>h <Plug>(easymotion-linebackward)
            map <Leader>j <Plug>(easymotion-j)
            map <Leader>k <Plug>(easymotion-k)
			map <Leader>l <Plug>(easymotion-lineforward)
			" Move to line
			map <Leader>L <Plug>(easymotion-bd-jk)
			nmap <Leader>L <Plug>(easymotion-overwin-line)
			" Move to word
			map  <Leader>w <Plug>(easymotion-bd-w)
			nmap <Leader>w <Plug>(easymotion-overwin-w)

            " <Leader>f{char} to move to {char}
			map  <Leader>f <Plug>(easymotion-bd-f)
			nmap <Leader>f <Plug>(easymotion-overwin-f)

            " Require tpope/vim-repeat to enable dot repeat support
            " Jump to anywhere with only `s{char}{target}`
			" `s<CR>` repeat last find motion.
			nmap s <Plug>(easymotion-s)
			nmap s2 <Plug>(easymotion-s2)
			" Bidirectional & within line 't' motion
			nmap t <Plug>(easymotion-t)
			nmap t <Plug>(easymotion-t2)
			omap t <Plug>(easymotion-bd-tl)
			map  / <Plug>(easymotion-sn)
			omap / <Plug>(easymotion-tn)

			" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
			" Without these mappings, `n` & `N` works fine. (These mappings just provide
			" different highlight method and have some other features )
			map  n <Plug>(easymotion-next)
			map  N <Plug>(easymotion-prev)
        endif
    " }

    " BufferLine {
        " If you want to see the full path, press {count}Ctrl-G
        " https://vi.stackexchange.com/questions/104/how-can-i-see-the-full-path-of-the-current-file
        if isdirectory(expand("~/.vim/bundle/vim-bufferline"))
            let g:bufferline_echo = 0 " hidden buffers in command bar
            let g:bufferline_show_bufnr = 0
        endif
    " }

    " EditorConfig {
        if isdirectory(expand("~/.vim/bundle/editorconfig-vim"))
            let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*'] "Excluded patterns.
            "let g:EditorConfig_disable_rules = ['trim_trailing_whitespace'] "Disable rules
        endif
    " }

    " Cheat.sh {
        if count(g:spf13_bundle_groups, 'cheat.sh')
            let g:syntastic_javascript_checkers = [ 'jshint' ]
            let g:syntastic_ocaml_checkers = ['merlin']
            let g:syntastic_python_checkers = ['pylint']
            let g:syntastic_shell_checkers = ['shellcheck']
        endif
    " }
    "
    " Nvim problems {
        if has('nvim') && isdirectory(expand("~/.vim/bundle/FixCursorHold.nvim/"))
            let g:cursorhold_updatetime = 100
        endif
    " }

    " Cmake {
        if isdirectory(expand("~/.vim/bundle/vim-cmake/"))
            let g:cmake_link_compile_commands = 1
            noremap <leader>mg :CMakeGenerate<cr>
            noremap <leader>mb :CMakeBuild<cr>
        endif
    " }

    " cargo shortcuts
    " r. cargo-process-repeat
    " r/ cargo-process-search
    " r= cargo-process-fmt
    " ra cargo-process-add
    " rc cargo-process-build
    " rd cargo-process-doc
    " re cargo-process-bench
    " rf cargo-process-feature
    " ri cargo-process-init
    " rl cargo-process-clipy
    " rn cargo-process-new
    " ro cargo-process-outdated
    " rr cargo-process-rm"
    " rt cargo-process-test"
    " ru cargo-process-update"
    " rv cargo-process-check"
    " rx cargo-process-run
    " rA cargo-process-audit"
    " rC cargo-process-clean"
    " rD cargo-process-doc-open
    " rE cargo-process-run-example"
    " rU cargo-process-upgrade
    " rX cargo-process-run-bin
    " Rust {
        if count(g:spf13_bundle_groups, 'rust')
            let g:rustfmt_autosave = 1
            let g:rust_clip_command = 'pbcopy'

            noremap <Leader>r/ :Cargo -- search
            noremap <Leader>r= :Cargo -- fmt<CR>
            noremap <Leader>ra :Cargo -- add
            noremap <Leader>rc :Cbuild<CR>
            noremap <Leader>rd :Cdoc<CR>
            noremap <Leader>re :Cbench<CR>
            noremap <Leader>rf :Cargo -- feature
            noremap <Leader>ri :Cinit<CR>
            noremap <Leader>rl :Cargo -- clipy
            noremap <Leader>rn :Cnew
            noremap <Leader>ro :Cargo -- outdated
            noremap <Leader>rr :Cargo -- rm
            noremap <Leader>rt :Ctest -- --nocapture --test-threads=1<CR>
            noremap <Leader>ru :Cupdate
            noremap <Leader>rv :Ccheck<CR>
            noremap <Leader>rx :Crun<CR>
            noremap <Leader>rA :Cargo -- audit
            noremap <Leader>rC :Cclean<CR>
            noremap <Leader>rD :Cdoc -- --open<CR>
            noremap <Leader>rE :Crun -- --example=
            noremap <Leader>rX :Crun -- --bin=
            noremap <Leader>r: :Cargo
        endif
    " }

    " Golang {
        if count(g:spf13_bundle_groups, 'go')
            let g:go_highlight_extra_types = 1
            let g:go_highlight_operators = 0
            let g:go_highlight_functions = 1
            let g:go_highlight_function_parameters = 1
            let g:go_highlight_function_calls = 1
            let g:go_highlight_types = 1
            let g:go_highlight_fields = 1
            let g:go_highlight_variable_declarations = 1
            let g:go_highlight_variable_assignments = 1
            let g:go_highlight_methods = 1
            let g:go_highlight_structs = 1
            let g:go_highlight_operators = 1
            let g:go_highlight_build_constraints = 1
            let g:go_fmt_command = "goimports"
            let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
            let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
            au FileType go nmap <Leader>odoc <Plug>(go-doc)
            "au FileType go nmap <Leader>odocs <Plug>(go-doc-split)
            au FileType go nmap <Leader>odocv <Plug>(go-doc-vertical)
            "au FileType go nmap <Leader>odoctb <Plug>(go-doc-tab)
            au FileType go nmap <Leader>odocb <Plug>(go-doc-browser)
            au FileType go nmap <Leader>odef <Plug>(go-def)
            "au FileType go nmap <Leader>odefs <Plug>(go-def-split)
            "au FileType go nmap <Leader>odefv <Plug>(go-def-vertical)
            "au FileType go nmap <Leader>odeftb <Plug>(go-def-tab)
            "au FileType go nmap <Leader>odeft <Plug>(go-def-type)
            "au FileType go nmap <Leader>odeftv <Plug>(go-def-type-vertical)
            "au FileType go nmap <Leader>odefts <Plug>(go-def-type-split)
            "au FileType go nmap <Leader>odeftt <Plug>(go-def-type-tab)
            "au FileType go nmap <Leader>odefs <Plug>(go-def-stack)
            "au FileType go nmap <Leader>odefsc <Plug>(go-def-stack-clear)
            "au FileType go nmap <Leader>odefp <Plug>(go-def-pop)
            au FileType go nmap <Leader>oimpl <Plug>(go-implements)
            au FileType go nmap <Leader>oi <Plug>(go-info)
            au FileType go nmap <Leader>ore <Plug>(go-rename)
            au FileType go nmap <Leader>or <Plug>(go-run)
            au FileType go nmap <Leader>ob <Plug>(go-build)
            au FileType go nmap <Leader>ot <Plug>(go-test)
            au FileType go nmap <Leader>ode <Plug>(go-describe)
            au FileType go nmap <Leader>ocov <Plug>(go-coverage)
            au FileType go nmap <Leader>ogen <Plug>(go-generate)
            au FileType go nmap <Leader>oca <Plug>(go-callers)
            au FileType go nmap <Leader>ocas <Plug>(go-callstack)
            au FileType go nmap <Leader>ochp <Plug>(go-channelpeers)
            au FileType go nmap <Leader>oref <Plug>(go-referrers)
            au FileType go nmap <Leader>opto <Plug>(go-pointsto)
        endif
    " }

    " TextObj Sentence {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

    " TextObj Quote {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_quote
                autocmd!
                autocmd FileType markdown call textobj#quote#init()
                autocmd FileType textile call textobj#quote#init()
                autocmd FileType text call textobj#quote#init({'educate': 0})
            augroup END
        endif
    " }

    " TODO unfinished configuration
    " Todo Comments {
        if has('nvim') && count(g:spf13_bundle_groups, 'writing')
lua <<EOF
require("todo-comments").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
}
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
    defaults = {
        mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
        },
    },
}
EOF
            nnoremap <leader>xx <cmd>TroubleToggle<cr>
            nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
            nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
            nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
            nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
            nnoremap gR <cmd>TroubleToggle lsp_references<cr>
        endif
    " }

    " " PIV {
    "     if isdirectory(expand("~/.vim/bundle/PIV"))
    "         let g:DisableAutoPHPFolding = 0
    "         let g:PIVAutoClose = 0
    "     endif
    " " }

    " matchit.zip {
        "  if isdirectory(expand("~/.vim/bundle/matchit.zip"))
        "      let b:match_ignorecase = 1
        "  endif
    " }

    " Choosewin {
        if isdirectory(expand("~/.vim/bundle/vim-choosewin"))
            nmap  -  <Plug>(choosewin)
            let g:choosewin_overlay_enable = 1
        endif
    " }

    " vim-floaterm {
        if isdirectory(expand("~/.vim/bundle/vim-floaterm"))
            let g:floaterm_autoclose = 2
            let g:floaterm_opener = 'tabe'"open file in new tab
            nnoremap <Leader>3n :FloatermNew nnn<CR>
            nnoremap <Leader>ft :FloatermToggle<CR>
        endif
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " " NerdTree {
    "     if isdirectory(expand("~/.vim/bundle/nerdtree"))
    "         map <C-e> <plug>NERDTreeTabsToggle<CR>
    "         map <leader>e :NERDTreeFind<CR>
    "         nmap <leader>nt :NERDTreeFind<CR>

    "         let NERDTreeShowBookmarks=1
    "         let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    "         let NERDTreeChDirMode=0
    "         let NERDTreeQuitOnOpen=1
    "         let NERDTreeMouseMode=2
    "         let NERDTreeShowHidden=1
    "         let NERDTreeKeepTreeInNewTab=1
    "         let g:nerdtree_tabs_open_on_gui_startup=0
    "     endif
    " " }

    " Tabularize {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " " PyMode {
    "     " Disable if python support not present
    "     if !has('python') && !has('python3')
    "         let g:pymode = 0
    "     endif

    "     if isdirectory(expand("~/.vim/bundle/python-mode"))
    "         let g:pymode_lint_checkers = ['pyflakes']
    "         let g:pymode_trim_whitespaces = 0
    "         let g:pymode_options = 0
    "         let g:pymode_rope = 0
    "     endif
    " " }

    " fzf {
        if isdirectory(expand("~/.vim/bundle/fzf")) &&
                    \ isdirectory(expand("~/.vim/bundle/fzf.vim"))
            function! RipgrepFzf(query, fullscreen)
                let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- %s || true'
                let initial_command = printf(command_fmt, shellescape(a:query))
                let reload_command = printf(command_fmt, '{q}')
                let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
                call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
            endfunction
            command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

            nnoremap <Leader>zf :Files<CR>
            nnoremap <Leader>zg :GFiles<CR>
            nnoremap <Leader>zgd :GFiles?<CR>
            nnoremap <Leader>zb :Buffers<CR>
            "nnoremap <Leader>zc :Colors<CR>
            nnoremap <Leader>zr :Rg<CR>
            nnoremap <Leader>zl :Lines<CR>
            nnoremap <Leader>zbl :BLines<CR>
            nnoremap <Leader>zt :Tags<CR>
            nnoremap <Leader>zbt :BTags<CR>
            nnoremap <Leader>zm :Marks<CR>
            nnoremap <Leader>zw :Windows<CR>
            nnoremap <Leader>zle :Locate <Space>
            nnoremap <Leader>zh :History<CR>
            nnoremap <Leader>zh: :History:<CR>
            nnoremap <Leader>zsh :History/<CR>
            "nnoremap <Leader>zss :Snippets<CR> " coc-snippets take care of this
            nnoremap <Leader>zc :Commits<CR>
            nnoremap <Leader>zbc :BCommits<CR>
            nnoremap <Leader>z :Commands<CR>
            nnoremap <Leader>zmp :Maps<CR>
            nnoremap <Leader>zht :Helptags<CR>
            nnoremap <Leader>zft :Filetypes<CR>
        endif
    " }

    " vim-clap {
        if isdirectory(expand("~/.vim/bundle/vim-clap/"))
            "let g:clap_enable_background_shadow = v:false
            let g:clap_layout = { 'relative': 'editor' }
            let g:clap_provider_grep_executable = "rg"
            let g:clap_provider_grep_opts = '-H --no-heading --smart-case --hidden -g "!.git/"'
            let g:clap_provider_grep_delay = 10

            nnoremap <Leader>zf :Clap files<CR>
            nnoremap <Leader>zgf :Clap gfiles<CR>
            nnoremap <Leader>zgd :Clap git_diff_files<CR>
            nnoremap <Leader>zb :Clap buffers<CR>
            "nnoremap <Leader>zc :Clap colors<CR>
            nnoremap <Leader>zg :Clap grep<CR>
            nnoremap <Leader>zg2 :Clap grep2<CR>
            nnoremap <Leader>zl :Clap lines<CR>
            nnoremap <Leader>zbl :Clap blines<CR>
            nnoremap <Leader>zpt :Clap proj_tags<CR>
            nnoremap <Leader>zt :Clap tags<CR>
            nnoremap <Leader>zm :Clap marks<CR>
            nnoremap <Leader>zw :Clap windows<CR>
            nnoremap <Leader>zlt :Clap loclist<CR>
            nnoremap <Leader>zh :Clap history<CR>
            nnoremap <Leader>zch :Clap command_history<CR>
            nnoremap <Leader>zsh :Clap search_history<CR>
            "nnoremap <Leader>zs :Snippets<CR>
            nnoremap <Leader>zc :Clap commits<CR>
            nnoremap <Leader>zbc :Clap bcommits<CR>
            nnoremap <Leader>zc: :Clap command<CR>
            nnoremap <Leader>zmp :Clap maps<CR>
            nnoremap <Leader>zrf :Clap recent_files<CR>
            nnoremap <Leader>zdj :Clap dumb_jump<CR>
            nnoremap <Leader>zj :Clap jumps<CR>
            nnoremap <Leader>zqf :Clap quickfix<CR>
            nnoremap <Leader>zr :Clap registers<CR>
            nnoremap <Leader>zp :Clap providers<CR>
            nnoremap <Leader>zht :Clap help_tags<CR>
            nnoremap <Leader>zft :Clap filetypes<CR>
        endif
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_cache_dir = expand("~/.vim/tmp/ctrlp")
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            let g:ctrlp_extensions = []
            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                call add(g:ctrlp_extensions, 'funky')

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " TagBar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :G<CR>
            nnoremap <silent> <leader>gd :G diff<CR>
            nnoremap <silent> <leader>gc :G commit<CR>
            nnoremap <silent> <leader>gb :G blame<CR>
            nnoremap <silent> <leader>gl :G log<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}
    "
    " Git-blame {
        if isdirectory(expand("~/.vim/bundle/git-blame.vim/"))
            nnoremap <Leader>bb :<C-u>call gitblame#echo()<CR>
        endif
    " }

    " FIXME: Isn't this for Syntastic to handle?
    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " Wildfire {
        let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " lightline {
        if isdirectory(expand("~/.vim/bundle/lightline.vim/"))
            set showtabline=2
            autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
            function! LightlineGitBlame() abort
                let blame = get(b:, 'coc_git_blame', '')
                " return blame
                return winwidth(0) > 120 ? blame : ''
            endfunction
			let g:lightline = {
				\ 'active': {
				\   'left': [
                \       [ 'mode', 'paste' ],
				\       [ 'cocstatus', 'currentfunction', 'readonly', 'absolutepath', 'modified' ],
                \       [ 'ctrlpmark', 'git', 'diagnostic', 'method' ],
                \   ],
                \   'right': [ [ 'lineinfo' ],
                \              [ 'percent' ],
                \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
				\ },
                \ 'tabline': {
                \   'left': [ ['buffers'] ],
                \   'right': [ ['close'] ]
                \ },
				\ 'component_function': {
				\   'cocstatus': 'coc#status',
				\   'currentfunction': 'CocCurrentFunction',
                \   'blame': 'LightlineGitBlame',
				\ },
            	\ 'component_expand': {
				\   'buffers': 'lightline#bufferline#buffers',
                \   'syntastic': 'SyntasticStatuslineFlag',
				\ },
                \ 'component_type': {
                \   'buffers': 'tabsel'
                \ },
                \ 'component_raw' : {
                \   'buffers': 1,
                \ }
			\ }
            let g:lightline#bufferline#show_number  = 4
            let g:lightline#bufferline#shorten_path = 1
            let g:lightline#bufferline#auto_hide = 0
        endif
    " }
    " vim-clang-format {
        if isdirectory(expand("~/.vim/bundle/vim-clang-format/"))
            let g:clang_format#auto_format_on_insert_leave=1
        endif
    " }
" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        " set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME."/.vim/tmp/"
        " let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " TODO:
        " Specifing a different directory that doesn't in ~/.vim/ directory will
        " make coc not working. and I can't figure it out at the moment.
        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        " if exists('g:spf13_consolidated_directory')
        "     let common_dir = g:spf13_consolidated_directory . prefix
        " else
        "     let common_dir = parent . '/.' . prefix
        " endif
        let common_dir = parent

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory, 'p')
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " " Initialize NERDTree as needed {
    " function! NERDTreeInitAsNeeded()
    "     redir => bufoutput
    "     buffers!
    "     redir END
    "     let idx = stridx(bufoutput, "NERD_tree")
    "     if idx > -1
    "         NERDTreeMirror
    "         NERDTreeFind
    "         wincmd l
    "     endif
    " endfunction
    " " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

    function! s:IsSpf13Fork()
        let s:is_fork = 0
        let s:fork_files = ["~/.vimrc.fork", "~/.vimrc.before.fork", "~/.vimrc.bundles.fork"]
        for fork_file in s:fork_files
            if filereadable(expand(fork_file, ":p"))
                let s:is_fork = 1
                break
            endif
        endfor
        return s:is_fork
    endfunction

    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction

    function! s:EditSpf13Config()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.before")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.bundles")

        execute bufwinnr(".vimrc") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.local")

        if <SID>IsSpf13Fork()
            execute bufwinnr(".vimrc") . "wincmd w"
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.fork")
        endif

        execute bufwinnr(".vimrc.local") . "wincmd w"
    endfunction

    execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
    execute "noremap " . s:spf13_apply_config_mapping . " :source ~/.vimrc<CR>"
" }

" Use fork vimrc if available {
    if filereadable(expand("~/.vimrc.fork"))
        source ~/.vimrc.fork
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }
endif
