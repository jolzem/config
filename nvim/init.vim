" init autocmd
autocmd!
set number relativenumber " Show absolute line numbers on the left.
filetype plugin on " Auto-detect un-labeled filetypes
syntax on " Turn syntax highlighting on
set ai " Sets auto-indentation
set si " Sets smart-indentation
set cursorline " Highlight current cursor line
set tabstop=2 " Tab equal 2 spaces (default 4)
set shiftwidth=2 " Arrow function (>>) creates 2 spaces
set expandtab " Use spaces instead of a tab charater on TAB
set smarttab " Be smart when using tabs
set hlsearch " When searching (/), highlights matches as you go
set incsearch " When searching (/), display results as you type (instead of only upon ENTER)
set smartcase " When searching (/), automatically switch to a case-sensitive search if you use any capital letters
set ttyfast " Boost speed by altering character redraw rates to your terminal
set showmatch " Show matching brackets when text indicator is over them
set noerrorbells " Silence the error bell
set novisualbell " Visually hide the error bell
set encoding=utf8 " Set text encoding as utf8
set clipboard+=unnamedplus " Use the OS clipboard by default
set showtabline=2 " Use tabline
set splitright " split to the right instead of left
set nowrap
set bg=dark
set wildmode=longest,list,full

" PLUGINS
" download to ~/.local/share/nvim/site/autoload/plug.vim
call plug#begin("~/.local/share/nvim/site/autoload/plugged")
  Plug 'junegunn/goyo.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'https://github.com/jiangmiao/auto-pairs.git'
  Plug 'lervag/vimtex'
  Plug 'https://github.com/ap/vim-css-color'
  Plug 'https://github.com/907th/vim-auto-save.git'
  Plug 'https://github.com/alvan/vim-closetag'
  Plug 'vim-airline/vim-airline'
  Plug 'https://github.com/github/copilot.vim'
  Plug 'https://github.com/morhetz/gruvbox'
call plug#end()

let g:vimtex_view_method = 'zathura'
" let g:vimtex_view_forward_search_on_start = 0
let g:auto_save = 1
let mapleader =","
let g:airline#extensions#tabline#enabled = 1

color gruvbox

" REMAPPING
" jump to last known position when opening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

map <C-g> :Goyo<CR>
imap <C-g> <esc>:Goyo<CR>a

map ,, :keepp /<++><CR>ca<
imap ,, <esc>:keepp /<++><CR>ca<

" indent with tab
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
vnoremap <Tab> >>
inoremap <Tab> <Esc>>>a
nnoremap <Tab> >>
inoremap <S-Tab> <Esc><<a
nnoremap <S-Tab> <<

" jump to beginning of selection when exiting visual mode
vnoremap <Esc> o<Esc>

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

autocmd BufWritePre,BufRead *.tex :VimtexCompile " init autocompiling tex docs
autocmd VimLeave *.tex :!texclear % " clear tex junk when closing tex file
autocmd BufWritePre * %s/\s\+$//e " auto delete trailing white space on save
autocmd BufWritePost *.vim source %

" LaTeX shortcuts
autocmd FileType tex inoremap <leader>b \textbf{}<Left>
autocmd FileType tex inoremap <leader>u \underline{}<Left>
autocmd FileType tex inoremap <leader>i \textit{}<Left>
autocmd FileType tex inoremap <leader>s \section{}<Left>
autocmd FileType tex inoremap <leader>ss \subsection{}<Left>
autocmd FileType tex inoremap <leader>sss \subsubsection{}<Left>
autocmd FileType tex inoremap <leader>l \begin{itemize}<CR><++><CR>\end{itemize},,
autocmd FileType tex inoremap <leader>o \begin{enumerate}<CR><++><CR>\end{enumerate},,
autocmd FileType tex inoremap <leader>c {\tt  }<Left><Left>
