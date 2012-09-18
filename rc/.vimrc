"=======================configure variable===============
let s:xxx = 0



"=======================general==========================


if(has("win32") || has("win95") || has("win64") || has("win16")) "判定当前操作系统类型
    let g:iswindows=1
    let g:isunix=0
else
    let g:iswindows=0
    let g:isunix=1
endif





set nocompatible
filetype plugin indent on
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim

"set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction





syntax on
set modeline
set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1

"设置忽略大小写，比如在搜索的时候
set ignorecase
"设置鼠标为可行
set mouse=a
"永远显示状态行
"set laststatus=2

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
" 使backspace正常处理indent, eol, start等
set backspace=indent,eol,start
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,[,]

"设置默认目录
if(g:isunix==1)
    cd ~/projects/vim
else
    cd E:\Document\Vim
endif
"设置当前文件目录
set autochdir

colorscheme torte

"cscope
if has("cscope")
    "set csprg=/usr/local/bin/cscope
    "set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif


"=============================AutoCommand===========================

"AutoCommand 
"新建.c,.h,.sh,.java文件，自动插入文件头 
"autocmd BufNewFile *.[ch],*.sh,*.cpp,*.java exec ":call SetTitle()" 
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


"每当文件保存时，就自动更新当前目录的tags, cscope
"autocmd! bufwritepost *.c,*.h,*.cpp call Update_current_tags_and_cscope()


"==========================映射===============================

"Set mapleader 
let mapleader = "," 
let g:mapleader = ","

"绑定自动补全的快捷键<C-X><C-O>到<leader>; 
imap <leader>; <C-X><C-O>

"设置tab操作的快捷键，绑定:tabnew到<leader>t，绑定:tabn, :tabp到<leader>n, 
"<leader>p 
map <leader>t :tabedit 
"map <leader>n :tabn<CR> 
"map <leader>p :tabp<CR>
map <leader>h :help 
"map <leader>w :w!<CR>
map <leader>w :update<CR>
if(g:isunix==0)
    map <leader>usaco :call OpenTemplateFile("D:\\My Documents\\Dev C++ project\\OJ\\USACO\\Section.cpp")<CR>
    map <leader>poj :call OpenTemplateFile("D:\\My Documents\\Dev C++ project\\OJ\\POJ\\template.cpp")<CR>
else
    "map <leader>test :call OpenTemplateFile("~/project/vim/template.cpp")<CR>
endif

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
map <F7> :clist<cr>

"注释
map <C-s> :call Annotation()<cr>

imap <F5> <Esc><F5>
imap <F6> <Esc><F6>
imap <F7> <Esc><F7>
imap <F9> <Esc><F9>   
imap <C-F9> <Esc><C-F9>   
imap <C-ENTER> <Esc>o   
inoremap ( ()<ESC>i
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>




"cscope
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>


"手动更新tags, cscope
"map <F12> :call Update_current_tags_and_cscope()<CR>



"abbr s1 scanf("%d", &);<left><left>
"abbr s2 scanf("%d%d", & , &);<left><left><left><left><left><left>
"abbr s3 scanf("%d%d%d", & , & , &);<left><left><left><left><left><left><left><left><left>
"abbr p1 printf("%d\n",);<left><left>
"abbr p2 printf("%d %d\n", ,);<left><left><left><left>
"abbr p3 printf("%d %d %d\n", , ,);<left><left><left><left><left><left>
"abbr if if ()<left>
"abbr ie if () ;<cr> else ;<up><left><left><left>

abbr fi for (int i = 0; i < ; i++)<left><left><left><left><left><left><left>
abbr fi1 for (int i = 1; i <= ; i++)<left><left><left><left><left><left><left>
abbr fj for (int j = 0; j < ; j++)<left><left><left><left><left><left><left>
abbr fj1 for (int j = 1; j <= ; j++)<left><left><left><left><left><left><left>
abbr fk for (int k = 0; k < ; k++)<left><left><left><left><left><left><left>
abbr fk1 for (int k = 1; k <= ; k++)<left><left><left><left><left><left><left>
abbr fp for (int p = 0; p < ; p++)<left><left><left><left><left><left><left>
abbr fp1 for (int p = 1; p <= ; p++)<left><left><left><left><left><left><left>
"abbr ww while()<cr>{<cr>}<up><up><right><right><right><right><right>
"abbr ca int Case;<cr>scanf("%d", &Case);<cr> for (int i = 1; i <= Case; i++) <cr>{<cr>};<up><enter>
"abbr dou double 
"abbr bo bool 

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




"产生stl_tags
"ctags -R -F -B -f ~/ctags --c++-kinds=+p --fields=+iaS --links=no  --extra=+qf -h .h. --langmap=c++:.h.    /usr/include/


"更新tags,cscope
func! Update_current_tags_and_cscope()
	silent ! ctags -R -F -B --c++-kinds=+p --fields=+iaS --extra=+qf .
    if(g:iswindows!=1)
        silent! execute "!find . -name '*.cc' -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
    else
        silent! execute "!dir /s/b *.cc,*.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
    endif
    silent! execute "!cscope -bq"
    "execute "normal :"
    if filereadable("cscope.out")
        silent! cs kill -1
        "cs reset
        silent! cs add cscope.out
    endif
endfunc




"打开指定（模板）文件
func! OpenTemplateFile(file)
    exec "e ".a:file
endfunc
 

"加注释
func! Annotation()
    if match(getline('.'), '//') == 0
        exec "normal 0xx"
    else
        exec "normal 0i//\<ESC>"
    endif
endfunc


"括号补全
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf







"定义函数SetTitle，自动插入文件头 
func! SetTitle()

call setline(1, "//#######################################################################") 
call append(line("."), "//# Author: lucas") 
call append(line(".")+1, "//# Created Time: ".strftime("%c")) 
call append(line(".")+2, "//# File Name: ".expand("%")) 
call append(line(".")+3, "//# Description: ") 
call append(line(".")+4, "//#######################################################################") 
if &filetype == 'c' 
call append(line(".")+5, "#include <stdio.h>") 
call append(line(".")+6, " ") 
call append(line(".")+7, "int main(){") 
call append(line(".")+8, " ") 
call append(line(".")+9, " return 0;")
call append(line(".")+10, "}") 
call append(line(".")+6, " ") 
elseif &filetype == 'cpp' 
call append(line(".")+5, "#include <iostream>") 
call append(line(".")+6, " ") 
call append(line(".")+7, "int main(){") 
call append(line(".")+8, " ") 
call append(line(".")+9, " return 0;")
call append(line(".")+10, "}") 
call append(line(".")+6, " ") 
elseif &filetype == 'java' 
call append(line(".")+5, "public class ".expand("%<").expand("{")) 
call append(line(".")+6, " public static void main(String[] args){") 
call append(line(".")+7, " ") 
call append(line(".")+8, " System.out.println();")
call append(line(".")+9, " }") 
call append(line(".")+10, "}") 
call append(line(".")+11, " ") 
endif 
endfunc





"ctags,cscope设置
"代码补全配置
"function! Do_CsTag()
"    let dir = getcwd()
"    if filereadable("tags")
"        if(g:iswindows==1)
"            let tagsdeleted=delete(dir."\\"."tags")
"        else
"            let tagsdeleted=delete("./"."tags")
"        endif
"        if(tagsdeleted!=0)
"            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
"            return
"        endif
"    endif
"    if has("cscope")
"        silent! execute "cs kill -1"
"    endif
"    if filereadable("cscope.files")
"        if(g:iswindows==1)
"            let csfilesdeleted=delete(dir."\\"."cscope.files")
"        else
"            let csfilesdeleted=delete("./"."cscope.files")
"        endif
"        if(csfilesdeleted!=0)
"            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
"            return
"        endif
"    endif
"    if filereadable("cscope.out")
"        if(g:iswindows==1)
"            let csoutdeleted=delete(dir."\\"."cscope.out")
"        else
"            let csoutdeleted=delete("./"."cscope.out")
"        endif
"        if(csoutdeleted!=0)
"            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
"            return
"        endif
"    endif
"    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
"        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
"    endif
"    if(executable('cscope') && has("cscope") )
"        if(g:iswindows!=1)
"            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
"        else
"            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
"        endif
"        silent! execute "!cscope -b"
"        execute "normal :"
"        if filereadable("cscope.out")
"            silent! execute "cs add cscope.out"
"        endif
"    endif
"endfunction





"==========================插件设置=============================

"ide configure
map <F12> :call OpenTagbarAndNERDTree()<CR>
function! OpenTagbarAndNERDTree()
  exec 'TagbarToggle'
  exec 'NERDTreeToggle'
endfunc


"tagbar config
let g:tagbar_width = 28

"WinManager
let g:persistentBehaviour=0

let g:NERDTree_title='NERD Tree'
function! NERDTree_Start()
    exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
    return 1
endfunction

let g:Tagbar_title='Tagbar'
function! Tagbar_Start()
    exec 'TagbarOpen'
endfunction
function! Tagbar_IsValid()
    return 1
endfunction

"nmap <F12> :WMToggle<cr>
"let g:winManagerWindowLayout='NERDTree|TagList'
let g:winManagerWindowLayout='NERDTree|Tagbar'
"let g:winManagerWindowLayout='FileExplorer|TagList'


"Grep
"nnoremap <silent> <F3> :Grep<CR>


"nerd tree
let NERDTreeWinSize=30


"pyflakes


"neocomplcach
let g:neocomplcache_enable_at_startup = 1 


"snipMate

"Gtags
map <F2> :Gtags 
map <F3> :GtagsCursor 


"csindent

"nerdcomment

"nerdcommenter

"gdbmgr

"bufexplorer

"=========================== unused plugins ==========================


"插件Taglist的设置
"TlistUpdate可以更新tags
"map <F12> :silent! Tlist<CR> "按下F7就可以呼出了
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
"是否一直处理tags.1:处理;0:不处理
let Tlist_Process_File_Always=0 "不是一直实时更新tags，因为没有必要
let Tlist_Inc_Winwidth=0


"插件omnicppcomplete设置
"关闭omnicppcomplete提示变量定义的预览窗口
set completeopt=menu
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_SelectFirstItem = 2
"
if(g:isunix==0)
    set tags+=D:\stl_tags
else
    set tags+=~/.vim/stl_tags,~/workspace/coding/tags,~/workspace/coding/ImageCapture
endif



"插件acp设置
let g:acp_enableAtStartup = 0
" 自动完成设置 禁止在插入模式移动的时候出现 Complete 提示
let g:acp_mappingDriven = 1
let g:acp_ignorecaseOption = 0
" 自动完成设置为 Ctrl + p 弹出
let g:acp_behaviorKeywordCommand = "\<C-p>"
let g:acp_completeoptPreview = 0
let g:acp_behaviorKeywordLength = 2

"neocomplcache
let g:neocomplcache_enable_at_startup = 1

"========================others=======================================

"enable ctrl-s in terminal
if (g:isunix == 1)
  silent ! stty ixoff -ixon
endif




"====================================================================
