"+++++++++++++++++++++++++++++++++++++++++++"
" TODO: rearrange this file by filetype"
"=======================configure variable===============
let s:xxx = 0

if(has("win32") || has("win95") || has("win64") || has("win16")) "判定当前操作系统类型
    let g:iswindows=1
    let g:isunix=0
else
    let g:iswindows=0
    let g:isunix=1
endif

"=======================general==========================

set nocompatible
filetype plugin indent on
source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vim



syntax on
set modeline
set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1

"设置忽略大小写，比如在搜索的时候
set ignorecase
"设置鼠标为可行
set mouse=a
"永远显示状态行
set laststatus=2

"自动缩进设置 
set cindent 
set smartindent 
set autoindent
set wrap

set guioptions+=T
set number
set cursorline
set tabstop=4
set cindent shiftwidth=4
set expandtab
set showmatch
set autoread
set hlsearch
set incsearch 
set ruler
set showcmd

" cursorcolumn
" set cursorcolumn

" colorcolumn
set textwidth=78
set colorcolumn=+1
" override by ftscript under /usr/**/vim73/ftplugin/c.vim", implement this in autocmd
" set formatoptions+=1
set formatoptions+=l

"设置折叠 
set foldcolumn=2 
set foldmethod=indent 
set foldlevel=3

"自动保存
"set autowriteall

"显示字节偏移量
"set statusline=%o

set nobackup
"set nowritebackup

"在输入命令时列出匹配项目
set wildmenu
set wildmode=longest:full,full

" 使backspace正常处理indent, eol, start等
set backspace=indent,eol,start
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,[,]

" 文件搜索路径，向上搜索(for gf op)
set path+=;
set path+=/usr/include/c++/**,/usr/include/**,/usr/local/include/**,/usr/lib/gcc/**2/include*/**
set path+=~/workspace/coding/.ymake-out/dbg/thrift-out

"设置默认目录
if(g:isunix==1)
    cd ~/workspace/vim
else
    cd E:\Document\Vim
endif
"设置当前文件目录
set autochdir

" colorscheme torte


"=============================AutoCommand===========================

"AutoCommand 
"新建文件后，自动定位到文件末尾 
autocmd BufNewFile * normal G


"设置Java代码的自动补全 
au FileType java setlocal omnifunc=javacomplete#Complete

"When .vimrc is edited, reload it
if(g:isunix==1)
    autocmd! bufwritepost .vimrc source ~/.vimrc
else
    autocmd! bufwritepost _vimrc source $VIM/_vimrc
endif

au FileType c,cpp,java set formatoptions+=1|set formatoptions-=l | set formatoptions+=t

au FileType python set cursorcolumn | call s:python_gf()

au FileType * try | execute "compiler ".&filetype | catch /./ | endtry

"==========================映射===============================

"Set mapleader 
let mapleader = "," 
let g:mapleader = ","

"绑定自动补全的快捷键<C-X><C-O>到<leader>; 
" imap <leader>; <C-X><C-O>

"设置tab操作的快捷键，绑定:tabnew到<leader>t，绑定:tabn, :tabp到<leader>n, 
"<leader>p 
map <leader>t :tabedit 
"map <leader>n :tabn<CR> 
"map <leader>p :tabp<CR>
map <leader>h :help 
"map <leader>w :w!<CR>
map <leader>w :update<CR>

"使用<leader>e打开当前文件同目录中的文件 
if(g:isunix==1)
    map ,e :e <C-R>=expand("%:p:h")."/"<CR>
else 
    map ,e :e <C-R>=expand("%:p:h")<CR>
endif

"Fast reloading of the .vimrc
"map <leader>s :source $VIM/_vimrc<cr>
"Fast editing of .vimrc
if(g:isunix==1)
    map <leader>vimrc :e ~/.vimrc<cr>
else
    map <leader>vimrc :e $VIM/_vimrc<cr>
endif


"设置程序的运行和调试的快捷键F9和Ctrl-F9 
"set makeprg=g++\ %\ -g\ -o\ %<.exe
"map <F9> :cd %:h<cr>:w!<cr>:make<cr><C-L>:cl<cr>
map <F9> :call Compile()<CR>
map <C-F9> :call Run()<CR><CR>
map <F8> :call Debug()<CR>


"错误列表
map <F5> :cp<cr>
map <F6> :cnext<cr>
map <F7> :QFtoggle<cr>

imap <F5> <Esc><F5>
imap <F6> <Esc><F6>
imap <F7> <Esc><F7>
imap <F9> <Esc><F9>   
imap <C-F9> <Esc><C-F9>   
imap <C-ENTER> <Esc>o   


"================================================================func===========================================================

"定义Compile函数，用来调用进行编译和运行 
func! Compile() 
    update
    "C/C++程序 
    if &filetype == 'c' || &filetype == 'cpp'
        if(g:isunix==1)
            set makeprg=g++\ %\ -g\ -o\ %<.out
        else
            set makeprg=g++\ %\ -g\ -o\ %<.exe
        endif
    "Java程序 
    elseif &filetype == 'java' 
        set makeprg=javac\ %
    "python program
    elseif &filetype == 'python'
        set makeprg=python\ %
    "shell scripts
    elseif &filetype == 'sh'
        set makeprg=sh\ %
    endif 
    make
    redraw
    let errorlist = getqflist()
    if !empty(errorlist)
        cl
    else
        echohl ErrorMsg | echo "没有错误！" | echohl None 
    endif
endfunc 
"结束定义Compile


"定义Run函数，用来调用进行编译和运行 
func! Run() 
    update
    "C/C++程序 
    if &filetype == 'c' || &filetype == 'cpp'
        if(g:isunix==1)
            exec "!gnome-terminal --command=\"bash -c 'time ./%<.out; read -p \\\"  Press Enter...\\\"'\"&"
        else
            exec "!%<.exe"
        endif
    "Java程序 
    elseif &filetype == 'java' 
        exec "!java %<" 
    "python
    elseif &filetype == 'python'
        if(g:isunix==1)
            exec "!gnome-terminal --command=\"bash -c 'time python %; read -p \\\"  Press Enter...\\\"'\"&"
        else 
            exec "!python %"
        endif
    endif 
endfunc 
"结束定义Run

"定义Debug函数，用来调试程序 
func! Debug() 
    update
    "C程序 
    if &filetype == 'c' || &filetype == 'cpp'
        if(g:isunix==1)
            exec "!g++ % -g -o %<.out" 
            exec "!gdb %<.out" 
        else
            exec "!g++ % -g -o %<.exe" 
            exec "!gdb %<.exe" 
        endif
    "Java程序 
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!jdb %<" 
    "python
    elseif &filetype == 'python'
        exec "!pdb %"
    endif 
endfunc 
"结束定义Debug

"toggle quickfix
function! s:qf_toggle() 
    for i in range(1, winnr('$')) 
        let bnum = winbufnr(i) 
        if getbufvar(bnum, '&buftype') == 'quickfix' 
            cclose 
            wincmd p
            return 
        endif 
    endfor 
    botright copen 8
endfunction 

command! QFtoggle call s:qf_toggle() 

function! s:gtags_update()
    let l:result = system('global -u')
    redraw!
    if v:shell_error
        echohl ErrorMsg | echo l:result[:-2] | echohl None
    else
        hi SucceedMsg term=standout cterm=bold ctermfg=7 ctermbg=2 gui=bold guifg=White guibg=Green
        echohl SucceedMsg | echo "global update SUCCEED!" | echohl None
    endif
endfunction

function! s:python_gf()
python << EOF
import os
import sys
import vim
vim.command(r"setlocal path=.,,")
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
        pass
EOF
endfunction



"==========================插件设置=============================

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:

" original repos on github
"
" Bundle 'tpope/vim-fugitive'
" Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}


" vim-scripts repos
"
" Bundle 'Command-T'
" Bundle 'Conque-Shell'
Bundle 'fugitive.vim'
" Bundle 'pyflakes.vim'
Bundle 'Tagbar'
" Bundle 'The-NERD-tree'
Bundle 'The-NERD-Commenter'
Bundle 'grep.vim'
Bundle 'neocomplcache'
Bundle 'snipMate'
" Bundle 'csindent.vim'
Bundle 'bufexplorer.zip'
Bundle 'Auto-Pairs'
Bundle 'vcscommand.vim'
" Bundle 'pathogen.vim'
" Bundle 'neocomplcache-snippets_complete'
" Bundle 'ShowMarks'
" Bundle 'SuperTab'
" Bundle 'STL-improved'
" Bundle 'autoload_cscope.vim'
" Bundle 'FuzzyFinder'
" Bundle 'L9'
Bundle 'a.vim'
" Bundle 'mru.vim'
" Bundle 'lookupfile'
" Bundle 'genutils'
" Bundle 'JavaScript-Indent'
" Bundle 'ZenCoding.vim'
" Bundle 'vim-jsbeautify'
" Bundle 'einars/js-beautify'
Bundle 'sprsquish/thrift.vim'
" Bundle 'std_c.zip'
" Bundle 'easytags.vim'
Bundle 'TagHighlight'
Bundle 'Indent-Guides'
Bundle 'Yggdroot/indentLine'
Bundle 'DoxygenToolkit.vim'
" Bundle 'nsf/gocode'
Bundle 'clang-complete'
Bundle 'Shougo/neocomplcache-clang_complete'
Bundle 'Shougo/neosnippet'
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/syntastic'
Bundle 'klen/python-mode'
Bundle 'vim-scripts/vim-json-bundle'

" Bundle 'ZenCoding.vim'
Bundle 'vividchalk.vim'
Bundle 'molokai'
Bundle 'surround.vim'
Bundle 'NrrwRgn'
Bundle 'Align'
Bundle 'EasyMotion'
Bundle 'matchit.zip'
Bundle 'Vim-R-plugin'
Bundle 'tpope/vim-pathogen'
Bundle 'mileszs/ack.vim'
Bundle 'vimwiki'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'jnwhiteh/vim-golang'
Bundle 'garyharan/vim-proto'
" Bundle 'andrep/vimacs'
Bundle 'maxbrunsfeld/vim-emacs-bindings'
Bundle 'ervandew/screen'
Bundle 'm2ym/rsense'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'lucapette/vim-ruby-doc'
Bundle 'danchoi/ri.vim'
" Bundle 'astashov/vim-ruby-debugger'


" non github repos
"
" Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on     " required!
" or 
" filetype plugin on          " to not use the indentation settings set by plugins









"ide configure
map <F12> :call OpenTagbarAndNERDTree()<CR>
function! OpenTagbarAndNERDTree()
  exec 'TagbarToggle'
  exec 'NERDTreeToggle'
endfunc


"tagbar config
let g:tagbar_width = 28


"Grep
"seted


"nerd tree
let NERDTreeWinSize=30


"pyflakes
"seted


"neocomplcach
let g:neocomplcache_enable_at_startup = 1 

"neocomplcache-snippets_complete


"snipMate
let g:snips_author = 'ludaoyuan1989@gmail.com (Daoyuan Lu)'
"seted

"Gtags
map <F2> :Gtags 
map <F3> :GtagsCursor 
command! GtagsUpdate call s:gtags_update()
"au BufWritePost *.[ch],*.[CH],*.cpp,*.hpp,*.cxx,*.hxx,*.c++,*.cc,*.java,*.php,*.php3,*.phtml,*.[sS] call s:gtags_update()

"csindent
let g:csindent_ini='~/.vim/bundle_vundle_improper/csindent/csindent/.vim_csindent.ini'

"nerdcommenter
let NERDSpaceDelims=1
"seted

"gdbmgr

"bufexplorer
"seted

"Auto Pairs
"seted

"vcscommand
let VCSCommandMapPrefix='<leader>v'
"seted

"Conque Shell
map <c-x><c-b>n :ConqueTerm bash<cr>
map <c-x><c-b>h :ConqueTermSplit bash<cr>
map <c-x><c-b>v :ConqueTermVSplit bash<cr>
map <c-x><c-b>t :ConqueTermTab bash<cr>
imap <c-x><c-b>n :ConqueTerm bash<cr>
imap <c-x><c-b>h :ConqueTermSplit bash<cr>
imap <c-x><c-b>v :ConqueTermVSplit bash<cr>
imap <c-x><c-b>t :ConqueTermTab bash<cr>
"seted

"command-t
"seted

"python.vim : Enhanced version of the python syntax highlighting script 
"seted

"google.vim : Indent file for Google C++ Coding Style 
"seted

"fugitive
"seted

"pathogen.vim
call pathogen#infect('bundle_vundle_improper')
"seted




"
"c/c++ complete
"python cscope


au BufRead,BufNewFile *.thrift set filetype=thrift
" au! Syntax thrift source ~/.vim/thrift.vim"

" neocomplcache-clang_complete
let g:neocomplcache_force_overwrite_completefunc=1

" clang-complete
let g:clang_use_library = 1
let g:clang_complete_macros = 1
let g:clang_debug = 1
" let g:clang_complete_auto = 0


" Lokaltog/vim-powerline
let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme = 'solarized256'
let g:Powerline_theme = 'default'
" let g:Powerline_stl_path_style = 'relative'

set guifont=anonymous\ Pro-Powerline-Powerline.ttf
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif



" altercation/vim-colors-solarized
" if has('gui_running')
"     set background=light
" else
"     set background=dark
"     let g:solarized_termcolors=256
" endif
" colorscheme solarized

colorscheme Tomorrow-Night-Bright


" Indent-Guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size=1
hi IndentGuidesOdd  guibg=red   ctermbg=3
hi IndentGuidesEven guibg=green ctermbg=4


" kien/ctrlp.vim
" if (g:isunix)
"     let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
" else
"     let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
" endif


" Shougo/neosnippet
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" if has('conceal')
"     set conceallevel=2 concealcursor=i
" endif

" let g:neosnippet#snippets_directory="~/.vim/snippets/"
" let g:neosnippet#enable_snipmate_compatibility=1
let g:neosnippet#disable_select_mode_mappings = 0


" a.vim
let g:alternateNoDefaultAlternate=1



" task list
map <leader>todo <Plug>TaskList

" Bundle 'andrep/vimacs'
let g:VM_Enabled = 1
let g:VM_SingleEscToNormal = 0
let g:VM_NormalMetaXRemap = 0


" Bundle 'ervandew/screen'


" Bundle 'm2ym/rsense'
" Replace $RSENSE_HOME with the directory where RSense was installed
let g:rsenseHome = "/home/daoyuan/.vim/bundle/rsense"
let g:rsenseUseOmniFunc = 1


" Bundle 'Yggdroot/indentLine'
let g:indentLine_enabled = 0


" Bundle 'klen/python-mode'
let g:pymode_lint_checker = "pyflakes"


" Bundle 'scrooloose/syntastic'
let g:syntastic_cpp_include_dirs = [ '/home/daoyuan/workspace/coding/' ]
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': [],
            \ 'passive_filetypes': ['python'] }


"=========================== unused plugins ==========================


"======================== os related =======================================

"enable ctrl-s in terminal
if (g:isunix == 1)
    silent ! stty ixoff -ixon
endif




"====================================================================
set showcmd
