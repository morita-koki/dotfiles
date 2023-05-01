# alias setting 
if which lsd > /dev/null; then
	alias ls="lsd"
else
	alias ls="ls --color=auto"
fi

if which nvim > /dev/null; then
	alias vim="nvim"
fi

alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias l="clear && ls"


# pyenv setting
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"




