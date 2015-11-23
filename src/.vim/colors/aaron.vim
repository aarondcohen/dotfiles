set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "aaron"

if &t_Co == '256'

	hi Normal     cterm=none ctermbg=none ctermfg=White
	hi Cursor     cterm=none ctermbg=White ctermfg=none
	hi MatchParen cterm=Bold ctermbg=none ctermfg=208

	hi Comment    ctermfg=176 " Purple
	hi Constant   ctermfg=51  " 39 Deep Blue
	hi Identifier ctermfg=LightRed
	hi Include    ctermfg=DarkGreen
	hi PreProc    ctermfg=DarkGreen " 29 34
	hi Todo       cterm=None ctermbg=Yellow ctermfg=Black
	hi Type       cterm=Bold ctermfg=Cyan

	" Custom Groups
	hi Operators cterm=none ctermfg=LightRed
	hi Reserved  cterm=Bold ctermfg=220
	hi Variable  cterm=none ctermfg=39 " 228 " White

	" Vim Features
	hi DiffAdd    cterm=none ctermfg=Black ctermbg=Lightgreen
	hi DiffChange cterm=none ctermfg=Black ctermbg=Magenta
	hi DiffDelete cterm=none ctermfg=Black ctermbg=Red
	hi DiffText   cterm=none ctermfg=Black ctermbg=Lightgreen

else
	hi Normal     cterm=none ctermbg=none ctermfg=White
	hi Cursor     cterm=none ctermbg=White ctermfg=none
	hi MatchParen cterm=Bold ctermfg=Yellow

	hi Comment    ctermfg=Magenta
	hi Constant   ctermfg=Cyan
	hi Include    ctermfg=Green
	hi PreProc    ctermfg=Green
	hi Statement  cterm=Bold ctermfg=White
	hi Todo       cterm=None ctermbg=Yellow ctermfg=Black
	hi Type       cterm=Bold ctermfg=Cyan

	" Custom Groups
	hi Operators cterm=none ctermfg=White
	hi Reserved  cterm=Bold ctermfg=Yellow
	hi Variable  cterm=none ctermfg=Blue
endif

" Universal Custom Links
hi link Regex         String
hi link String        Constant
hi link NoVarConstant Variable

" C++
hi link cConditional  Reserved
hi link cConstant     NoVarConstant
hi link cCppString    NoVarConstant
hi link cLabel        Reserved
hi link cOperator     Reserved
hi link cRepeat       Reserved
hi link cStatement    Reserved
hi link cUserLabel    Reserved
hi link cppAccess     Reserved
hi link cppExceptions Reserved
hi link cppOperator   Reserved
hi link cppStatement  Reserved

" Perl
hi link perlConditional              Reserved
hi link perlFiledescRead             Operators
hi link perlFiledescStatement        Variable
hi link perlFiledescStatementComma   Variable
hi link perlFiledescStatementNocomma Variable
hi link perlMatchStartEnd            Regex
hi link perlOperator                 Reserved
hi link perlPackageDecl              Normal
hi link perlRepeat                   Reserved
hi link perlStatement                Reserved
hi link perlStatementControl         Reserved
hi link perlStatementInclude         Include
hi link perlStatementPackage         Include
hi link perlVarNotInMatches          Variable
hi link perlVarPlain                 Variable
hi link perlVarPlain2                Variable
hi link perlVarSimpleMember          Variable
hi link perlVarSlash                 Variable

" Git
hi link gitconfigAssignment String
hi link gitconfigBoolean    Constant
hi link gitconfigNone       Operators
hi link gitconfigNumber     Constant
hi link gitconfigSection    PreProc
hi link gitconfigVariable   Variable
hi link gitrebaseAction     Reserved
hi link gitrebaseEdit       gitrebaseAction
hi link gitrebaseFixup      gitrebaseAction
hi link gitrebasePick       gitrebaseAction
hi link gitrebaseReword     gitrebaseAction
hi link gitrebaseSquash     gitrebaseAction

" Vim
hi link vimCommand   Reserved
hi link vimHiKeyList Operators
hi link vimHighlight Reserved
hi link vimNumber    NoVarConstant
hi link vimOper      Operators
hi link vimString    NoVarConstant

