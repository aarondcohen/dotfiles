# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
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
	PS1=$PS1'$(if __git_ps1 > /dev/null 2>&1; then __git_ps1 "[%s]"; fi;)'
fi

PS1=$PS1' '

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

# Aliases
alias vi='vim'
alias movie-info='mplayer -vo null -nosound -identify -frames 0'

# Environment Variables for various programs
export GIT_EDITOR=vi
export GIT_PAGER='less -SFR'

source ~/perl5/perlbrew/etc/bashrc
