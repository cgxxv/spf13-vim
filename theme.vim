    if count(g:spf13_bundle_groups, 'vim-colors-solarized')
        let g:solarized_termcolors=256 "24bits
        let g:solarized_termtrans = 1
        let g:solarized_contrast="high"
        syntax enable
        set background=dark
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'nvim-colors-solarized')
        "if exists('+termguicolors')
        "    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        "    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        "    set termguicolors
        "endif
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        let g:solarized_termcolors=256 "24bits
        let g:solarized_termtrans = 1
        let g:solarized_contrast="high"
        syntax enable
        set background=light
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'NeoSolarized')
        let g:neosolarized_contrast = "high"
        let g:neosolarized_vertSplitBgTrans = 0
        set background=dark "light"
        colorscheme NeoSolarized
    elseif count(g:spf13_bundle_groups, 'vim-solarized8')
        let g:solarized_termtrans = 1
        let g:solarized_extra_hi_groups = 1
        set background=dark
        colorscheme solarized8
    elseif count(g:spf13_bundle_groups, 'vim-one')
        set background=dark " for the dark version
        colorscheme one
    elseif count(g:spf13_bundle_groups, 'vim-github-colorscheme')
        colorscheme github
    endif
