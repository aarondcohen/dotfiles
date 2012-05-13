set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "test"


if &t_Co == '256'

	hi Normal     cterm=none ctermbg=none ctermfg=White
	hi Cursor     cterm=none ctermbg=White ctermfg=none
	hi MatchParen cterm=Bold ctermbg=none ctermfg=208

	hi Comment    ctermfg=176 " Purple
	hi Constant   ctermfg=39  " Deep Blue
	hi String     ctermfg=51  " Aqua
	hi Identifier ctermfg=LightRed
	"hi Statement  cterm=Bold ctermfg=220
	hi PreProc    ctermfg=DarkGreen " 29 34
	hi Include    ctermfg=DarkGreen
	hi link perlStatementInclude Include
	hi Type       cterm=Bold ctermfg=Cyan
	"hi Special    cterm=Bold ctermfg=LightRed
	"hi Repeat     cterm=Bold ctermfg=LightRed
	hi Todo       cterm=None ctermbg=Yellow ctermfg=Black

	hi Operators cterm=none ctermfg=LightRed
	hi link perlFiledescRead Operators
	hi link vimHiKeyList     Operators
	hi link vimOper          Operators

	hi link Regex String
	hi link perlMatchStartEnd Regex

	hi Reserved cterm=Bold ctermfg=220
	hi link perlConditional      Reserved
	hi link perlOperator         Reserved
	hi link perlRepeat           Reserved
	hi link perlStatement        Reserved
	hi link perlStatementControl Reserved
	hi link vimCommand           Reserved
	hi link vimHighlight         Reserved

	hi Variable   ctermfg=White
	hi link perlFiledescStatement        Variable
	hi link perlFiledescStatementComma   Variable
	hi link perlFiledescStatementNocomma Vairable
	hi link perlVarNotInMatches          Variable
	hi link perlVarPlain                 Variable
	hi link perlVarPlain2                Variable
	hi link perlVarSimpleMember          Variable
	hi link perlVarSlash                 Variable

else
	hi Normal     cterm=none ctermbg=none ctermfg=White
	hi Cursor     cterm=none ctermbg=White ctermfg=none
	hi MatchParen ctermbg=none ctermfg=Yellow

	hi Comment    ctermfg=Magenta
	hi Constant   ctermfg=Blue
	hi String     ctermfg=Cyan
	hi Statement  cterm=Bold ctermfg=White
	hi Type       cterm=None ctermfg=White
	hi Todo       cterm=None ctermbg=Yellow ctermfg=Black
endif
