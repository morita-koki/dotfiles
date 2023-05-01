# basic setting

LANG=en_US.UTF-8

# dircolor setting
if [ -f ~/.dircolors  ]; then
	if type dircolors > /dev/null 2>&1; then
		eval $(dircolors ~/.dircolors)
	elif type gdircolros > /dev/null 2>&1; then
		eval $(gdircolors ~/.dircolors)
	fi
fi


# history setting
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHSIT=10000
setopt HIST_IGNORE_DUPS     # do not recode duprecated cmd
setopt HIST_IGNORE_ALL_DUPS # do not record duprecated cmd
setopt HIST_IGNORE_SPACE    # do not record cmd whose start char is space
setopt HIST_FIND_NO_DUPS    # reduce duprecated cmd when finding
setopt HIST_REDUCE_BLANKS   # remove blank
setopt HIST_NO_STORE        # do not recode history cmd
setopt share_history        # share history among the tmux panes and windows
unsetopt auto_remove_slash


# disable ctrl + s
stty stop undef
stty start undef




# function to refresh tmux env
if [ -n "$TMUX" ]; then
    function refresh {
        export OS=`tmux show-environment | grep ^OS | sed -e 's/OS=//g'`
        export DISPLAY=`tmux show-environment | grep ^DISPLAY | sed -e 's/DISPLAY=//g'`
        tmux source-file ~/.tmux.conf
    }
else
    function refresh {
        echo -n ""
    }
fi
autoload -Uz add-zsh-hook
add-zsh-hook preexec refresh


#########################
#      Zplug init       #
#########################
source ~/.zplug/init.zsh

#########################
#     Zplug plugins     #
#########################
autoload colors && colors
setopt prompt_subst

# manage zplug by zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# make command completion stronger
zplug "zsh-users/zsh-completions"
# make command auto suggestion based on history
zplug "zsh-users/zsh-autosuggestions"
# command line syntax highlight
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# interative git commands
zplug "wfxr/forgit", use:forgit.plugin.zsh
# useful change directory
zplug "b4b4r07/enhancd", use:init.sh
# load theme from local
# zplug "~/.zsh/themes/", from:local, use:bullet-train.zsh-theme, defer:3
zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, defer:3

# install check and then load
zplug check || zplug install
zplug load

#########################
#   enhancd settings    #
#########################
export ENHANCD_USE_FUZZY_MATCH=0 # do not use fuzzy match
export ENHANCD_DISABLE_HOME=1    # "cd" then go home
export ENHANCD_FILTER=fzf
export ENHANCD_AWK=awk

#########################
#     less settings     #
#########################
export LESS="-i -R -M"

#########################
#      fzf settings     #
#########################
export FZF_DEFAULT_OPTS='
    --height=40% --reverse --border
    --exit-0 --select-1
    --color fg:188,hl:103,fg+:222,bg+:234,hl+:104
    --color info:183,prompt:110,spinner:107,pointer:167,marker:215'
export FZF_CTRL_R_OPTS="
    --sort
    --preview 'echo {}'
    --preview-window down:3:hidden:wrap
    --bind '?:toggle-preview'"
export FZF_DEFAULT_COMMAND="fd --no-ignore-vcs --ignore-file ~/.ignore --hidden --follow"
[ -f ~/.fzf/zsh ] && source ~/fzf.zsh




#########################
#  completion settings  #
#########################
# enable completion
zmodload -i zsh/complist
autoload -Uz compinit && compinit

# colorized path completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose no
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# vim like movement when completion
zstyle ':completion:*:default' menu select=2
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char




# path setting
if [ -z "$TMUX" ];then
    export PATH=$HOME/local/bin:$PATH
    if [ -e ${HOME}/.poetry/bin ]; then
        export PATH=$HOME/.poetry/bin:$PATH
    fi
fi

# compile zshrc
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc
fi

# activate pyenv
eval "$(pyenv init -)"


export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
