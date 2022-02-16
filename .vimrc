"------------------------------------一般设置---------------------------------"
"设置文件改动后自动载入
set autoread
" 高亮当前行
set cursorline
" 允许插件
filetype plugin on
" 共享剪辑板
set clipboard=unnamed
" 检测文件类型
filetype on
" 不使用VI键盘模式
set nocompatible
" 语法高亮
set syntax=on
" 处理未保存文件弹出提示
set confirm
" 自动缩进
set autoindent
" TAB键宽度
set tabstop=4
" 统一缩进
set softtabstop=4
set shiftwidth=4
" 不用空格键代替TAB
set noexpandtab
" 显示行号
set number
" 历史记录数
set history=1000
" 搜索逐字符高亮
set hlsearch
set incsearch
" 编码设置
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,cp963
" 语言设置
set langmenu=zh_CN.UTF-8
" 特定文件载入特定缩进
filetype indent on
" 退格键可以跨行
set backspace=2
set whichwrap+=<,>,h,l
" 允许使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 高亮显示匹配的括号
set showmatch
set completeopt=longest,menu

" 显示状态栏
set laststatus=2

"---------------------------------------"
" 开启真彩色
if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

" 设置夜间背景
set background=dark

" 设置Vim主题
colorscheme material

" ----------------------------------配置插件---------------------------"
call plug#begin()

" 自动补全括号
" Github : https://github.com/jiangmiao/auto-pairs
Plug 'jiangmiao/auto-pairs'
" 底部状态栏美化
" Github : https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'
let g:lightline = { 'colorscheme': 'one' }
" one主题
" Github : https://github.com/rakr/vim-one
Plug 'rakr/vim-one'
let g:airline_theme='one'

" Material主题
" Github : https://github.com/kaicataldo/material.vim
Plug 'kaicataldo/material.vim', { 'branch': 'main'  }
let g:material_terminal_italics = 1
let g:material_theme_style = 'ocean'

" 代码补全
" Github : https://github.com/Shougo/deoplete.nvim
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1
" 使用LSP服务
" Github : https://github.com/autozimu/LanguageClient-neovim
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next','do': 'bash install.sh',}
" 目录树插件
" Github : https://github.com/scrooloose/nerdtree 
Plug 'preservim/nerdtree'
" 版本管理 :Magit
" Github : https://github.com/jreybert/vimagit
Plug 'jreybert/vimagit'

call plug#end()

"-----------------设置LSP--------------------------------------------"
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.c = ['clangd']
let g:LanguageClient_serverCommands.cpp = ['clangd']

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"----------------------------------配置快捷键-------------------------------------------------------

noremap <leader>dd :call LanguageClient#textDocument_definition()<cr>
noremap <leader>rr :call LanguageClient#textDocument_rename()<cr>
noremap <leader>hh :call LanguageClient#textDocument_hover()<cr>

nnoremap <leader>t :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
