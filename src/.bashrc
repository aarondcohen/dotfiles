# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_custom ]; then
	source ~/.bash_custom
fi

if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
	source ~/perl5/perlbrew/etc/bashrc
fi

# History Options
HISTCONTROL=ignoredups:ignoreboth:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend

# Color Options

# We have color support; assume it's compliant with Ecma-48
# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# a case would tend to support setf rather than setaf.)
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	PS1='[\[\033[01;32m\]\u@$HOSTNAME\[\033[00m\]][\[\033[01;34m\]\w\[\033[00m\]]'
else
	PS1='[\u@$HOSTNAME][\w]'
fi

if [ -f "$HOME/bin/git-completion.bash" ]; then
	. "$HOME/bin/git-completion.bash"
	PS1=$PS1'$(if __git_ps1 > /dev/null 2>&1; then __git_ps1 "[\[\033[01;35m\]%s\[\033[00m\]]"; fi;)'
fi

PS1=$PS1'\n'

# User specific aliases and functions
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls -px --group-directories-first --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
else
	alias ls='ls -px --group-directories-first'
fi

extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjfv $1 ;;
			*.tar.gz)  tar xzfv $1 ;;
			*.tar.xz)  tar xJfv $1 ;;
			*.bz2)     bunzip2 $1 ;;
			*.gz)      gunzip $1 ;;
			*.rar)     rar x $1 ;;
			*.tar)     tar xfv $1 ;;
			*.tbz2)    tar xjfv $1 ;;
			*.tgz)     tar xzfv $1 ;;
			*.zip)     unzip $1 ;;
			*.Z)       uncompress $1 ;;
			*.7z)      7z x $1 ;;
			*)         echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Aliases
alias cad='cat > /dev/null'
alias movie-info='mplayer -vo null -nosound -identify -frames 0'
alias vi='echo "Save the headache and type vim"'

# Environment Variables for various programs
export GIT_EDITOR=vim
export GIT_PAGER='less -SFR'
export LESS=''

