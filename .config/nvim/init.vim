" Fundamentals "{{{
" ---------------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set nocompatible
set number
syntax enable
set fileencodings=utf-8,sjis,euc-jp,latin
set encoding=utf-8
set title
set autoindent
set background=dark
set nobackup
set hlsearch
set showcmd
set cmdheight=1
set laststatus=2
set scrolloff=10
set expandtab
"let loaded_matchparen = 1
set shell=fish
set backupskip=/tmp/*,/private/tmp/*

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=

set nosc noru nosm
" Don't redraw while executing macros (good performance config)
set lazyredraw
"set showmatch
" How many tenths of a second to blink when matching brackets
"set mat=2
" Ignore case when searching
set ignorecase
" Be smart when using tabs ;)
set smarttab
" indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set backspace=start,eol,indent
" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r

"}}}

" Highlights "{{{
" ---------------------------------------------------------------------
set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

"}}}

" File types "{{{
" ---------------------------------------------------------------------
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript
" Fish
au BufNewFile,BufRead *.fish set filetype=fish

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

"}}}

" Imports "{{{
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif
if has('win32')
  runtime ./windows.vim
endif

runtime ./maps.vim
"}}}

" Syntax theme "{{{
" ---------------------------------------------------------------------

" true color
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  " Use NeoSolarized
  let g:gruvbox_termtrans=1
  runtime ./colors/Gruvbox.vim
  colorscheme Gruvbox
endif

"}}}

" Extras "{{{
" ---------------------------------------------------------------------
set exrc
"}}}
" Telescope Configuration "
 nnoremap <leader>ff <cmd>Telescope find_files<cr>
" Vimwiki conf
let g:wiki_root = '~/vimwiki'
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki/',
            \'syntax': 'markdown',
            \'ext': '.md'}]
hi link VimwikiHeader1 GruvboxRedBold
hi link VimwikiHeader2 GruvboxYellowBold
hi link VimwikiBold GruvboxGreenBold
hi link VimwikiItalic GruvboxBlueBold

function! MathAndLiquid()
    "" Define certain regions
    " Block math. Look for "$$[anything]$$"
    syn region math start=/\$\$/ end=/\$\$/
    " inline math. Look for "$[not $][anything]$"
    syn match math_block '\$[^$].\{-}\$'

    " Liquid single line. Look for "{%[anything]%}"
    syn match liquid '{%.*%}'
    " Liquid multiline. Look for "{%[anything]%}[anything]{%[anything]%}"
    syn region highlight_block start='{% highlight .*%}' end='{%.*%}'
    " Fenced code blocks, used in GitHub Flavored Markdown (GFM)
    syn region highlight_block start='```' end='```'

    "" Actually highlight those regions.
    hi link math Statement
    hi link liquid Statement
    hi link highlight_block Function
    hi link math_block Function
endfunction

" Call everytime we open a Markdown file
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown call MathAndLiquid()

" Vim-airline Conf
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
let g:airline_symbols = {}
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.notexists = '⚡'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#ignore_bufadd_pat = '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tabs = 0

let g:airline_left_sep=''
let g:airline_right_sep=''

" Window Navigation Binds
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

map <leader>t :NERDTreeToggle<CR>

" EXPERIMENTAL Vimtex Config with Zathura"
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Py Autocomplete conf
let g:deoplete#enable_at_startup = 0
let g:jedi#completions_command = "Tab"
" Debugger conf
"local dap = require('dap')
"dap.adapters.python = {
"  type = 'executable';
"  local venv = os.getenv("VIRTUAL_ENV")
"  command = vim.fn.getcwd() .. string.format("%s/bin/python",venv) 
"  args = { '-m', 'debugpy.adapter' };
"}
"local dap = require('dap')
"dap.configurations.python = {
"  {
"    -- The first three options are required by nvim-dap
"    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
"    request = 'launch';
"    name = "Launch file";

"    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
"
"    program = "${file}"; -- This configuration will launch the current file if used.
"    pythonPath = function()
"      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
"      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
"      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
"      local cwd = vim.fn.getcwd()
"      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
"        return cwd .. '/venv/bin/python'
"      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
"        return cwd .. '/.venv/bin/python'
"      else
"        return '/usr/bin/python'
"      end
"    end;
"  },
"}

