set nocompatible  " prevent vim from emulating vi bugs

""""""""""""""""""""""""""""
" Editing Options
""""""""""""""""""""""""""""

set autoindent    " indent based on the previous line
set backspace=indent,eol,start
"set copyindent    " copy indenting style of the line above
set encoding=utf8 " Make vim utf8 aware and safe
"set shiftwidth=2  " Set visual mode selection indents to 2 spaces
set showmatch     " Show matching brackets.
"set softtabstop=2 " Set backspace on indents to 2 spaces
"set tabstop=2     " Set tabs to 2 spaces

" Turn off all bells
set noerrorbells
set novisualbell
set t_vb=

" Enable limited mousing
"set mouse=nicr
"set clipboard=unnamed

""""""""""""""""""""""""""""
" Search Options
""""""""""""""""""""""""""""

set hlsearch   " highlight the search term
"set ignorecase " search is case insensitive
"set smartcase  " override ignorecase if search contains uppercase characters
set incsearch  " search as you type
set wrapscan   " searches wrap around the end of the file

""""""""""""""""""""""""""""
" Mode Options
""""""""""""""""""""""""""""

" fix completion modes
set completeopt=          " don't show the menu and just cycle through the options
set wildmode=longest,list " in ex mode, complete longest common string, then list alternatives (like bash)
set diffopt+=iwhite       " ignore whitespace in diffmode

""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')
"Plug 'altercation/vim-colors-solarized'
Plug 'gregsexton/matchtag'
Plug 'othree/yajs.vim'
call plug#end()


""""""""""""""""""""""""""""
" Custom File Types
""""""""""""""""""""""""""""

filetype indent plugin on " set indentation rules based on file type and enable filetype plugins

autocmd BufNewFile,BufRead *.jsx         set filetype=javascript
autocmd BufNewFile,BufRead *.md          set filetype=markdown
autocmd BufNewFile,BufRead *.t           set filetype=perl
autocmd BufNewFile,BufRead *.pp          set filetype=puppet
autocmd BufNewFile,BufRead *.cap,Capfile set filetype=ruby
autocmd BufNewFile,BufRead *.jbuilder    set filetype=ruby
autocmd BufNewFile,BufRead .bash_custom  set filetype=sh
autocmd BufNewFile,BufRead *.slim        set filetype=slim
autocmd BufNewFile,BufRead .vim_custom   set filetype=vim
autocmd BufNewFile,BufRead *.yaml,*.yml  set filetype=yaml

set shiftwidth=2 tabstop=2 noexpandtab " when there's no file type
autocmd FileType * set shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType eruby,puppet,ruby,slim,yaml set shiftwidth=2 softtabstop=2 tabstop=2 expandtab

""""""""""""""""""""""""""""
" Status Line
""""""""""""""""""""""""""""

" Format the statusline
set statusline=%f\ %y%r%m%=%-0(%l:%c/%L\ %3p%%%)
" set statusline=%f\ %y%r%m%=col\ %c\ line\ %1*%l%*/%L " set up statusline to show file, read-only, modified, file type, and line number
" Always show the statusline
set laststatus=2

""""""""""""""""""""""""""""
" Color Scheme Debugging
""""""""""""""""""""""""""""

syntax on    " Turn syntax highlighting on
"set t_Co=256 " Set the terminal to 256 color mode
colorscheme aaron

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

""""""""""""""""""""""""""""
" Useful Functions
""""""""""""""""""""""""""""

" remap tab to autocomplete words when not at the beginning of a line
function InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>



" Line Length
"highlight ColorColumn ctermbg=10
"set colorcolumn=81 " Show run on columns
highlight LongLineSoftOverrun ctermbg=DarkGray
highlight LongLineHardOverrun ctermbg=DarkRed
"sy match LongLineHardOverrun /^.\{120}\zs.\+/
"sy match LongLineSoftOverrun /^.\{80}\zs.\{1,40}/
autocmd BufNewFile,BufRead * call matchadd('LongLineSoftOverrun', '\%>80v.\+')
autocmd BufNewFile,BufRead * call matchadd('LongLineHardOverrun', '\%>120v.\+')



" highlight questionable whitespace differently depending on whether
" or not expandtab is set
highlight QuestionableWhitespace ctermbg=green guibg=green
function HighlightWhitespace()
	let matches = []
	let comment_start = get(GetCommentChars(), 0, '')
"	if &expandtab
		" highlight tabs not at the beginning of the line (but allow # for comments and % for mason),
		" and trailing whitespace not followed by the cursor
		" (maybe think about highlighting leading spaces not in denominations of tabstop?)
"		match QuestionableWhitespace /\(^[%#]\?\t*\)\@<!\t\|[ \t]\+\(\%#\)\@!$/
"	else
		" highlight any leading spaces (TODO: ignore spaces in formatted assignment statements),
		" tabs not at the beginning of the line (but allow # for comments and % for mason),
		" and trailing whitespace not followed by the cursor
"		match QuestionableWhitespace /^ \+\|\(^[%#]\?\t*\)\@<!\t\|[ \t]\+\(\%#\)\@!$/
"	endif

	"Non-tab followed by tab
	"TODO: handle case of begin-of-line comment followed by tab for noexpandtab
	call add(matches, '\([^\t]\)\@<=\t\+')
	"End-of-line space, except when typing
	call add(matches, '\s\+\%#\@<!$')

	if &expandtab
		call add(matches, '^\(\(' . comment_start . '\)? *\)\@=\t\+')
		"Non-tab followed by tab
		call add(matches, '\([^\t]\)\@<=\t\+')
	else
		call add(matches, '^\(\(' . comment_start . '\)?\t*\)\@= \+')

		"Tab followed by space
		call add(matches, '\(\t\)\@<= \+')
	endif

	exec 'match QuestionableWhitespace /' . join(matches, '\|') . '/'
endfunction
autocmd BufNewFile,BufRead * call HighlightWhitespace()



function GetCommentChars()
	let comment_start = '#'
	let comment_end   = ''

	if &filetype == 'cpp'
		let comment_start = '\/\/'
"		let comment_start = '\/\* '
"		let comment_end   = ' \*\/'
	endif
	if &filetype == 'css'
		let comment_start = '\/\* '
		let comment_end   = ' \*\/'
	endif
	if &filetype == 'haskell'
		let comment_start = '--'
	endif
	if &filetype == 'java'
		let comment_start = '\/\/'
"		let comment_start = '\/\* '
"		let comment_end   = ' \*\/'
	endif
	if &filetype == 'javascript'
		let comment_start = '\/\/'
	endif
	if &filetype == 'scss'
		let comment_start = '\/\/'
	endif
	if &filetype == 'sql'
"		let comment_start = '--'
		let comment_start = '\/\* '
		let comment_end   = ' \*\/'
	endif
	if &filetype == 'vim'
		let comment_start = '"'
	endif

	return [comment_start, comment_end]
endfunction



" toggle a comment for a line
" see http://www.perlmonks.org/?node_id=561215 for more info
function ToggleComment()
	let comment_chars = GetCommentChars()
	let comment_start = get(comment_chars, 0, '')
	let comment_end   = get(comment_chars, 1, '')

	" if the comment start is at the beginning of the line and isn't followed
	" by a space (i.e. the most likely form of an actual comment, to keep from
	" uncommenting real comments
	if getline('.') =~ ('^' . comment_start . '\( \w\)\@!')
		execute 's/^' . comment_start . '//'
		execute 's/' . comment_end . '$//'
	else
		execute 's/^/' . comment_start . '/'
		execute 's/$/' . comment_end . '/'
	endif
endfunction
map <silent> X :call ToggleComment()<cr>j

if filereadable($HOME . "/.vim_custom")
	so ~/.vim_custom
endif
