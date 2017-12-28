PS1=$'%n@%m:%~%% '
RPS1=$'%D'

## 補完時に大小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=1

autoload -U compinit && compinit

## options
setopt BASH_AUTO_LIST
setopt LIST_AMBIGUOUS
setopt AUTO_PUSHD
# kill ^D
setopt IGNOREEOF

## history
HISTFILE="$HOME/.zsh_history"
# memory history
HISTSIZE=16384
# file history
SAVEHIST=1638400
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_no_store
setopt share_history

## ビープを鳴らさない
setopt nobeep
setopt nolistbeep

autoload -Uz zmv
alias zrename='noglob zmv -W'

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -d  # clear
#bindkey -v # vi
bindkey -e #emacs
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
#bindkey "^R" history-incremental-search-backward
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^U" kill-whole-line

bindkey "^[u" undo
bindkey "^[r" redo

# OS dependancy
case "${OSTYPE}" in
darwin*)
    alias ls="ls -G -w"
    alias vi='vim'
    export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/man:$MANPATH
    ;;
freebsd*|linux*)
    alias ls="ls --color"
    export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    ;;
esac

# prompt
case ${UID} in
0)
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    autoload -Uz add-zsh-hook
    autoload -Uz colors
    colors
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git svn hg bzr
    zstyle ':vcs_info:*' formats '(%s)-[%b]'
    zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true

    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
        if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
            zstyle ':vcs_info:git:*' check-for-changes false
        else
            zstyle ':vcs_info:git:*' check-for-changes true
        fi
        zstyle ':vcs_info:git:*' stagedstr "+"
        zstyle ':vcs_info:git:*' unstagedstr "-"
        zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
        zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
    fi

    function _update_vcs_info_msg() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd _update_vcs_info_msg
    RPROMPT="%1(v|%F{green}%1v%f|)"
    #RPROMPT+="%(?..%?)"
    PROMPT="[%n@%m %~]"
    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${fg[cyan]}%}${PROMPT}%{${reset_color}%}"

    PROMPT+="%(?.%F{blue}%%%f.%F{red}%?>%f) "

    ;;
esac

#function zle-line-init zle-keymap-select {
#  case $KEYMAP in
#    vicmd)
#    PROMPT="[%{$fg_bold[red]%}NOR%{$reset_color%}] %{$fg_bold[white]%}%%%{$reset_color%} "
#    ;;
#    main|viins)
#    PROMPT="[%{$fg_bold[cyan]%}INS%{$reset_color%}] %{$fg_bold[white]%}%%%{$reset_color%} "
#    ;;
#  esac
#  zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# terminal configuration
case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

case "${TERM}" in
xterm|xterm-color)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

#source ~/.dotfiles/incr*.zsh
## source auto-fu.zsh

# Use coreutils commands, if they exists
if which gls > /dev/null 2>&1
then
    local myls='gls'
else
    local myls='ls'
fi
if $myls --color > /dev/null 2>&1
then
    local lscolor='--color'
else
    local lscolor='-G'
fi
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias st="git status"
alias where="command -v"
alias j="jobs -l"
alias grep="grep --color"
alias crypt="openssl enc -e -aes256 -k "
alias decrypt="openssl enc -d -aes256 -k "
alias clear2="echo -e '\026\033c'"

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias view='vim -R'

alias ls='$myls -hF $lscolor'    # add colors for filetype recognition
alias la="ls -la"
alias lf="ls -F"
alias ll="ls -lh"
alias lx='ls -lXB'              # sort by extension
alias lk='ls -lSr'              # sort by size
alias lc='ls -lcr'      # sort by change time  
alias lu='ls -lur'      # sort by access time   
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date

alias dstat-full='dstat -Tclmdrn --tcp'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'

# nvm
. ~/.nvm/nvm.sh
#nvm alias default v0.10.2
#nvm use "v0.10.28" >/dev/null

# ignore no matches found
setopt nonomatch

if [ -z "$JAVA_HOME" ]; then
    for candidate in \
        /usr/lib/jvm/java-1.7*/jre \
        /usr/lib/jvm/java-1.7* \
        /usr/lib/jvm/java-1.6*/jre \
        /usr/lib/jvm/java-1.6* \
        /usr/lib/jvm/jre-1.7* \
        /usr/lib/jvm/jre-1.6* \
        /usr/lib/j2sdk1.6-sun \
        /usr/java/jdk1.7* \
        /usr/java/jre1.7* \
        /usr/java/jdk1.6* \
        /usr/java/jre1.6* ; do
        if [ -e $candidate/bin/java ]; then
            export JAVA_HOME=$candidate
            break
        fi
    done
fi

export GOPATH=$HOME/golang
if [ -d "$GOPATH" ]; then
    export GOROOT=/usr/local/opt/go/libexec
    export PATH="${GOPATH}/bin:$PATH"
fi

if [[ -z $JAVA_HOME ]]; then
    # On OSX use java_home (or /Library for older versions)
    if [ "Darwin" = "$(uname -s)" ]; then
        if [ -x /usr/libexec/java_home ]; then
            export JAVA_HOME=$(/usr/libexec/java_home)
        else
            export JAVA_HOME=/Library/Java/Home
        fi
    fi
fi

if test -n "$SSH_AUTH_SOCK" -a -z "$TMUX" -a -n "$SSH_CLIENT" ; then
    ln -snf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

# OPAM configuration
if [ -f ~/.opam/opam-init/init.zsh ] ; then
    . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

if [ -d ~/.conscript/bin ] ; then
    export PATH="${HOME}/.conscript/bin:$PATH"
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

export EDITOR=vim

