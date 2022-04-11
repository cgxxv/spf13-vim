# This is another spf13-vim repo.

## NewFeatures
* Change vundle to vim-plug for fast plugin installation.
* Support coc.nvim for perfect lsp development.
* Remove OmniComplete, YouCompleteMe, Ctags, NerdTree configuration (They are already the yesterday).
* Support cheat.sh (A very good plugin for developer).
* Support editorconfig.
* Support fzf (The great command line fuzzy search).


## Installation
```bash
    sh <(curl https://raw.githubusercontent.com/cgxxv/spf13-vim/lsp/bootstrap.sh -L)
```

## Key-bindings

### Fzf

```vim
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
```

### coc.vim
```vim
nnoremap <silent><nowait> <Leader>cla  :<C-u>CocList diagnostics<cr>     " Show all diagnostics.
nnoremap <silent><nowait> <Leader>cle  :<C-u>CocList extensions<cr>      " Manage extensions.
nnoremap <silent><nowait> <Leader>clc  :<C-u>CocList commands<cr>        " Show commands.
nnoremap <silent><nowait> <Leader>clo  :<C-u>CocList outline<cr>         " Find symbol of current document.
nnoremap <silent><nowait> <Leader>cls  :<C-u>CocList -I symbols<cr>      " Search workspace symbols.
nnoremap <silent><nowait> <Leader>cj  :<C-u>CocNext<CR>                 " Do default action for next item.
nnoremap <silent><nowait> <Leader>ck  :<C-u>CocPrev<CR>                 " Do default action for previous item.
nnoremap <silent><nowait> <Leader>cp  :<C-u>CocListResume<CR>           " Resume latest coc list.
```

### fugitive
```vim
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
```

### and so on
refer the .vimrc
