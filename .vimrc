set nocompatible  " prevent vim from emulating vi bugs
set autoindent    " indent based on the previous line
set showmatch     " Show matching brackets.
set tabstop=2     " Set tabs to 2 spaces
set shiftwidth=2  " Set visual mode selection indents to 2 spaces
set encoding=utf8 " Make vim utf8 aware and safe

" Turn off all bells
set noerrorbells
set novisualbell
set t_vb=

syntax on         " Turn syntax highlighting on
set t_Co=256      " Set the terminal to 256 color mode
colorscheme aaron

" Format the statusline
set statusline=%f\ %y%r%m%=%-0(%l:%c/%L\ %3p%%%)
" Always show the statusline
set laststatus=2

" so $VIMRUNTIME/syntax/hitest.vim to view syntax

" adds to statusline
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}

" a little more informative version of the above
"nmap <Leader>sI :call <SID>SynStack()<CR>
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
