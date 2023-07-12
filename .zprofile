# alias setting

# if which lsd > /dev/null; then
# 	alias ls="lsd"
# fi


alias ls="ls --color=auto"


if which nvim > /dev/null; then
	alias vim="nvim"
fi

alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias l="clear && ls"


# history alias
alias h="history -100"


# vim alias
alias vim="nvim"
alias v="nvim"


# for wsl setting
alias clip="clip.exe"

# pyenv setting
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# git command alias
export ga="git add"
export gcm="git commit -m"
export gpush="git push"
export gpull="git pull"





