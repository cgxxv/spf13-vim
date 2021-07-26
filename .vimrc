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
            set shell=/bin/sh
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
    set foldenable                  " Auto fold code
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
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

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
                \ 'coc-json', 'coc-highlight', 'coc-snippets', 'coc-git', 'coc-emmet',
                \ 'coc-tsserver', 'coc-html', 'coc-css',
                \ 'coc-cmake', 'coc-sql', 'coc-sh', 'coc-markdownlint',
                \ 'coc-vimlsp', 'coc-phpls', 'coc-python',
                \ 'coc-clangd',
                \ 'coc-go',
                \ ]
        endif

        source ~/.vim/coc.vim
    endif
" }

" Plugins {
    " BufferLine {
        " If you want to see the full path, press {count}Ctrl-G
        " https://vi.stackexchange.com/questions/104/how-can-i-see-the-full-path-of-the-current-file
        if isdirectory(expand("~/.vim/bundle/vim-bufferline"))
            let g:bufferline_echo = 0 " hidden buffers in command bar
        endif
    " }

    " EditorConfig
        if isdirectory(expand("~/.vim/bundle/editorconfig-vim"))
            let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*'] "Excluded patterns.
            "let g:EditorConfig_disable_rules = ['trim_trailing_whitespace'] "Disable rules
        endif

    " Cheat.sh {
        if count(g:spf13_bundle_groups, 'cheat.sh')
            let g:syntastic_javascript_checkers = [ 'jshint' ]
            let g:syntastic_ocaml_checkers = ['merlin']
            let g:syntastic_python_checkers = ['pylint']
            let g:syntastic_shell_checkers = ['shellcheck']
        endif
    " }

    " Rust {
        if count(g:spf13_bundle_groups, 'rust')
            let g:rustfmt_autosave = 1
            let g:rust_clip_command = 'pbcopy'

            "" c. cargo-process-repeat
            " c/ cargo-process-search
            noremap <Leader>c/ :Cargo -- search
            " c= cargo-process-fmt
            noremap <Leader>c= :Cargo -- fmt<CR>
            " ca cargo-process-add
            noremap <Leader>ca :Cadd
            " cc cargo-process-build
            noremap <Leader>cc :Cbuild<CR>
            " cd cargo-process-doc
            noremap <Leader>cd :Cdoc<CR>
            " ce cargo-process-bench
            noremap <Leader>ce :Cbench<CR>
            " cf cargo-process-feature
            noremap <Leader>cf :Cargo -- feature +
            " ci cargo-process-init
            noremap <Leader>ci :Cinit<CR>
            " cl cargo-process-clipy
            noremap <Leader>cl :Cargo -- clipy
            " cn cargo-process-new
            noremap <Leader>cn :Cnew
            " co cargo-process-outdated
            noremap <Leader>co :Cargo -- outdated
            " cr cargo-process-rm"
            noremap <Leader>cr :Cargo -- rm
            " ct cargo-process-test"
            noremap <Leader>ct :Ctest -- --nocapture --test-threads=1<CR>
            " cu cargo-process-update"
            noremap <Leader>cu :Cupdate
            " cv cargo-process-check"
            noremap <Leader>cv :Ccheck<CR>
            " cx cargo-process-run
            noremap <Leader>cx :Crun<CR>
            " cA cargo-process-audit"
            noremap <Leader>cA :Cargo -- audit
            " cC cargo-process-clean"
            noremap <Leader>cC :Cclean<CR>
            " cD cargo-process-doc-open
            noremap <Leader>cD :Cdoc -- --open<CR>
            " cE cargo-process-run-example"
            noremap <Leader>cE :Crun -- --example=
            "" cU cargo-process-upgrade
            " cX cargo-process-run-bin
            noremap <Leader>cX :Crun -- --bin=
            noremap <Leader>cmd :Cargo
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
            au FileType go nmap <Leader>ggs <Plug>(go-implements)
            au FileType go nmap <Leader>ggi <Plug>(go-info)
            au FileType go nmap <Leader>gge <Plug>(go-rename)
            au FileType go nmap <leader>ggr <Plug>(go-run)
            au FileType go nmap <leader>ggb <Plug>(go-build)
            au FileType go nmap <leader>ggt <Plug>(go-test)
            au FileType go nmap <Leader>ggd <Plug>(go-doc)
            au FileType go nmap <Leader>ggv <Plug>(go-doc-vertical)
            au FileType go nmap <leader>ggo <Plug>(go-coverage)
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

    " " PIV {
    "     if isdirectory(expand("~/.vim/bundle/PIV"))
    "         let g:DisableAutoPHPFolding = 0
    "         let g:PIVAutoClose = 0
    "     endif
    " " }

    " Misc {
        " if isdirectory(expand("~/.vim/bundle/nerdtree"))
        "     let g:NERDShutUp=1
        " endif
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif
        if count(g:spf13_bundle_groups, 'defx')
            noremap <Leader>de :Defx<CR>
            source ~/.vim/defx.vim
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
            nnoremap <Leader>zf :Files<CR>
            nnoremap <Leader>zg :GFiles<CR>
            nnoremap <Leader>zG :GFiles?<CR>
            nnoremap <Leader>zb :Buffers<CR>
            nnoremap <Leader>zC :Colors<CR>
            nnoremap <Leader>zs :Rg<CR>
            nnoremap <Leader>zl :Lines<CR>
            nnoremap <Leader>zL :BLines<CR>
            nnoremap <Leader>zt :Tags<CR>
            nnoremap <Leader>zT :BTags<CR>
            nnoremap <Leader>zM :Marks<CR>
            nnoremap <Leader>zw :Windows<CR>
            nnoremap <Leader>zF :Locate <Space>
            nnoremap <Leader>zh :History<CR>
            nnoremap <Leader>zH :History:<CR>
            nnoremap <Leader>z/ :History/<CR>
            nnoremap <Leader>zS :Snippets<CR>
            nnoremap <Leader>zc :Commits<CR>
            nnoremap <Leader>zbm :BCommits<CR>
            nnoremap <Leader>z: :Commands<CR>
            nnoremap <Leader>zm :Maps<CR>
            nnoremap <Leader>zht :Helptags<CR>
            nnoremap <Leader>zft :Filetypes<CR>
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
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

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

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
            if !exists('g:airline_theme')
                let g:airline_theme = 'solarized'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
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
