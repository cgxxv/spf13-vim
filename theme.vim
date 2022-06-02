    if count(g:spf13_bundle_groups, 'vim-colors-solarized')
        let g:solarized_termcolors=256 "16 or 24bits
        let g:solarized_termtrans=1
        let g:solarized_contrast="high"
        syntax enable
        set background=dark
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'nvim-colors-solarized')
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        let g:solarized_termcolors=256 "24bits
        let g:solarized_termtrans=1
        let g:solarized_contrast="high"
        syntax enable
        set background=light
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'NeoSolarized')
        let g:neosolarized_contrast="high"
        let g:neosolarized_vertSplitBgTrans = 0
        set background=dark "light
        colorscheme NeoSolarized
    elseif count(g:spf13_bundle_groups, 'vim-solarized8')
        let g:solarized_termtrans=1
        let g:solarized_extra_hi_groups=1
        set background=dark
        colorscheme solarized8
    elseif count(g:spf13_bundle_groups, 'vim-one')
        set background=dark "light
        colorscheme one
    elseif count(g:spf13_bundle_groups, 'vim-github-colorscheme')
        colorscheme github
    elseif count(g:spf13_bundle_groups, 'dracula')
        colorscheme dracula
    elseif count(g:spf13_bundle_groups, 'material')
        " Fix italics in Vim
        if !has('nvim')
          let &t_ZH="\e[3m"
          let &t_ZR="\e[23m"
        endif
        let g:material_terminal_italics = 1
        let g:material_theme_style = 'darker'
        colorscheme material
    elseif count(g:spf13_bundle_groups, 'onehalf')
        syntax on
        set t_Co=256
        set cursorline
        colorscheme onehalfdark
        let g:airline_theme='onehalfdark'
    elseif count(g:spf13_bundle_groups, 'gruvbox')
        let g:gruvbox_italic=1
        colorscheme gruvbox
    elseif count(g:spf13_bundle_groups, 'molokai')
        let g:molokai_original = 1
        colorscheme molokai
    endif
