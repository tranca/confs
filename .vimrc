let use_epita_coding_style=1

set cb=autoselect
behave xterm
set nocompatible
set background=dark
set autoindent
set sw=2
set backspace=indent,eol,start
set whichwrap=b,s,l,h,<,>,[,]
set icon
set title
set showbreak=\\
set noeol
set et
set hlsearch
set keywordprg=man\ -k
set formatprg=fmt
set ttyfast
set hidden
set switchbuf=useopen
set showmatch
set matchtime=1
set showcmd
set lazyredraw
set viminfo='20,\"50
set history=40
set ruler
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set cpoptions=aABceFs
set smartcase
set incsearch
set autowrite
set laststatus=2
set statusline=[%n]\ %<%f\ %((%1*%M%*%R%Y)%)\ %=%-19(\Line\ [%4l/%4L]\ \Col\ [%02c%03V]%)\ ascii['%03b']\ %P
set expandtab
set number
colorscheme molokai

" Color the status line everytime
highlight StatusLine term=reverse  cterm=bold ctermfg=white ctermbg=lightblue gui=bold guifg=white guibg=blue

if has("mouse")
  set mouse=ar
  set mousemodel=extend
  set mousefocus
  set mousehide
endif

if has("gui_running")
  set lines=50
  set columns=80
  set guioptions=acmtl
  set guifont=7x13bold
  set noguipty
  set guicursor=i-ci:ver50-Cursor
  set guicursor=a:blinkon0
  " Change background only if in GUI (not in term)
  highlight Normal gui=NONE guibg=Black guifg=White
endif

filetype on

" Syntax ?
if has("syntax")
  syntax on
endif

" Filetype Settings [require autocmd]
if has("autocmd")
  autocmd BufReadPre /tmp/pico.*,mutt-* set filetype=mail
  autocmd FileType css set smartindent
  autocmd BufRead mutt-* set nobackup
  autocmd FileType make set shiftwidth=8
  autocmd BufEnter *.c,*.h set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-c nowrap cindent smartindent
  autocmd BufEnter *.y,*.yy set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-yacc nowrap cindent smartindent
  autocmd BufEnter *.l,*.ll set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-lex nowrap cindent smartindent
  autocmd BufEnter *.C,*.cpp,*.hh,*.cc,*.hxx set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-cpp nowrap cindent smartindent
  autocmd BufEnter *.java set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-java nowrap cindent

  if exists("use_epita_coding_style")
    autocmd BufEnter *.c,*.h,*.y,*.yy,*.l,*.ll,*.C,*.cpp,*.hh,*.cc,*.hxx,*.java set comments=sr:/*,mb:**,el:*/
  else
    autocmd BufEnter *.c,*.h,*.y,*.yy,*.l,*.ll,*.C,*.cpp,*.hh,*.cc,*.hxx,*.java set comments=sr:/*,mb:*,el:*/
  endif

  autocmd BufEnter *.rb set formatoptions=croql cpt=.,w,b,u,t,i,k~/.complete-ruby comments=sr:#,mb:#,el:# nowrap cindent smartindent
  autocmd BufEnter *.py set sw=4 sts=4 et ai cindent cinkeys=:,o,O
  autocmd BufEnter *.tex set cpt=.,w,b,u,t,i,k~/.complete-latex
  autocmd BufEnter *.htt set syntax=html
  autocmd BufEnter *.mly set syntax=yacc
  autocmd BufEnter *.m4 set formatoptions=croql cpt=.,w,b,u,t,i cindent smartindent tw=0 comments=sr:##,mb:##,el:##
  autocmd BufEnter *.str,*.sdf set sw=2 comments=sr:/*,mb:*,el:*/ cpt=.,w,b,u,t,i smartindent textwidth=0
  autocmd BufEnter Makefile,GNUmakefile set tabstop=8
  autocmd BufReadPost quickfix set wrap

  " Read PDFs in ViM.
  autocmd BufReadPre *.pdf set ro
  autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" - |fmt -csw78

  " automatically delete trailing DOS-returns and trailing whitespaces
  autocmd BufWritePre *.c,*.h,*.y,*.yy,*.l,*.ll,*.C,*.cpp,*.hh,*.cc,*.hxx,*.cxx,*.hpp,*.java,*.rb,*.py,*.m4,*.pl,*.pm silent! %s/[\r \t]\+$//
endif

" STUFFS
set complete=t,k,.,w,b,u,i
set infercase
set report=0
set wildmenu
set joinspaces
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(0,u0,)20,*30,g0

" Source stuffs

" returns a <tab> or a <C-N> depending on the context
" start of line -> tab
" otherwise -> <C-N> (autocompletion)
" (c) benoit.cerrina@writeme.com tip#102 @ vim.org
function InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

" Key mapping

" To manipulate compiling
map <F1> :!grunt dev<CR>
map <F2> :cp<CR>
map <F3> :cn<CR>
map <F4> :cwindow<CR>

" To comment
nmap <F5> I//<Space><Esc>j^
nmap <F6> ^3xj

" To indent
"inoremap <c-tab> <c-r>=InsertTabWrapper()<cr>
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
function CGlobalIndent()
  normal ==
endfun
nmap <F8> <Esc>:call CGlobalIndent()<CR>

" Paste
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Change buffer
map <C-N> :bn<CR>
map <C-P> :bp<CR>

" Hide coloration of found words
map <C-C> :nohlsearch<CR>

map <F9> :Dox<CR>
map <F10> :DoxHeader<CR>

" ?????
nmap <F12> :exe "ptj ".expand("<cword>")<CR>
imap <F12> :exe "ptj ".expand("<cword>")<CR>
nmap <S-F12> :exe "stj ".expand("<cword>")<CR>
imap <S-F12> :exe "stj ".expand("<cword>")<CR>
nmap <C-F12> :exe "tj ".expand("<cword>")<CR>
imap <C-F12> :exe "tj ".expand("<cword>")<CR>

" My plugins !!!!!!!!
source ~/.vim/plugins/cautofile.vim
"source ~/.vim/plugins/speedbar2.vim
source ~/.vim/plugins/cautocode.vim

imap <C-TAB> <C-V><C-TAB>

let c_gnu=1               " Highlight GNU gcc specific items ...
let c_space_errors=1      " ... and trailing spaces before a <Tab>

set foldmethod=indent
set foldignore=
vmap <space> za
nmap <space> za
highlight Folded ctermfg=darkgrey ctermbg=NONE
set foldtext=MyFoldText()
function MyFoldText()
  return substitute(v:folddashes, "-", "  ", "g")
endfunction

