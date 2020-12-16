    if count(g:spf13_bundle_groups, 'vim-colors-solarized') && filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        if has('nvim') && exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
        endif
        let g:solarized_termcolors="24bits"
        let g:solarized_termtrans=1
        let g:solarized_degrade=0
        let g:solarized_bold=0
        let g:solarized_contrast="high"
        let g:solarized_visibility="normal"
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'nvim-colors-solarized') && filereadable(expand("~/.vim/bundle/nvim-colors-solarized/colors/solarized.vim"))
        if exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
        endif
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        let g:solarized_termcolors="24bits"
        let g:solarized_termtrans=1
        let g:solarized_degrade=0
        let g:solarized_bold=0
        let g:solarized_contrast="high"
        let g:solarized_visibility="normal"
        colorscheme solarized
    elseif count(g:spf13_bundle_groups, 'NeoSolarized') && filereadable(expand("~/.vim/bundle/NeoSolarized/colors/NeoSolarized.vim"))
        if exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
        endif

        " Default value is "normal", Setting this option to "high" or "low" does use the
        " same Solarized palette but simply shifts some values up or down in order to
        " expand or compress the tonal range displayed.
        let g:neosolarized_contrast = "normal"

        " Special characters such as trailing whitespace, tabs, newlines, when displayed
        " using ":set list" can be set to one of three levels depending on your needs.
        " Default value is "normal". Provide "high" and "low" options.
        let g:neosolarized_visibility = "normal"

        " I make vertSplitBar a transparent background color. If you like the origin
        " solarized vertSplitBar style more, set this value to 0.
        let g:neosolarized_vertSplitBgTrans = 1

        " If you wish to enable/disable NeoSolarized from displaying bold, underlined
        " or italicized" typefaces, simply assign 1 or 0 to the appropriate variable.
        " Default values:
        let g:neosolarized_bold = 1
        let g:neosolarized_underline = 1
        let g:neosolarized_italic = 0

        " Used to enable/disable "bold as bright" in Neovim terminal. If colors of bold
        " text output by commands like `ls` aren't what you expect, you might want to
        " try disabling this option. Default value:
        let g:neosolarized_termBoldAsBright = 1
        
        colorscheme NeoSolarized
    elseif count(g:spf13_bundle_groups, 'vim-solarized8') && filereadable(expand("~/.vim/bundle/vim-solarized8/colors/solarized8.vim"))
        if exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
        endif

        let g:solarized_visibility = "normal" "one of 'normal' (default), 'low', 'high';
        let g:solarized_diffmode = "normal"   "one of 'normal' (default), 'low', 'high';
        let g:solarized_termtrans = 0         "make terminal background transparent if set to 1 (default: 0).

        let g:solarized_statusline = "normal" "one of 'normal' (default), 'low' or 'flat';
        let g:solarized_italics = 1           "set to 0 to suppress italics (default is 1).

        "set to 1 if you want to use the original Solarized's cursor style (default: 0). 
        "By default, the cursor is orange/red in light themes, and blue in dark themes 
        "(but please note that your terminal may override the cursor's color).
        let g:solarized_old_cursor_style = 0
        let g:solarized_use16 = 0             "set to 1 to force using your 16 ANSI terminal colors.
        "set to 1 to enable Solarized filetype-specific syntax highlighting groups (default is 0).
        "Please be aware that there is a long standing issue with syntax items defined in color schemes.
        let g:solarized_extra_hi_groups = 1

        colorscheme solarized8
    endif
