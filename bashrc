# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Bash Color
COLOR_RED="\e[31;40m"
COLOR_GREEN="\e[32;40m"
COLOR_YELLOW="\e[33;40m"
COLOR_BLUE="\e[34;40m"
COLOR_MAGENTA="\e[35;40m"
COLOR_CYAN="\e[36;40m"

COLOR_RED_BOLD="\e[31;1m"
COLOR_GREEN_BOLD="\e[32;1m"
COLOR_YELLOW_BOLD="\e[33;1m"
COLOR_BLUE_BOLD="\e[34;1m"
COLOR_MAGENTA_BOLD="\e[35;1m"
COLOR_CYAN_BOLD="\e[36;1m"

COLOR_NONE="\e[0m"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\A \[\033[01;32m\]\u\[\033[00m\]@\[\033[01;35m\]\h\[\033[36m\]\$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
#alias search='find ./ -path \"*\.svn\" -prune -o -type f -print | xargs grep --color=auto -I -n -s'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# For Fedora
if [ -f /usr/share/bash-completion/bash_completion ] && ! shopt -oq posix; then
    . /usr/share/bash-completion/bash_completion
fi

for i in /etc/bash_completion.d/*.bash; do
    if [ -r "$i" ]; then
        if [ "$PS1" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done

# Git
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] && ! shopt -oq posix; then
    . /usr/share/git-core/contrib/completion/git-prompt.sh
fi
#set vi style
#set -o vi

#
..() {
	num=$1
    test $1 || num=1
    seq=`seq $num`
    next=`printf '../%.0s' {$seq}`
    cd $next
    ls
}

search() {
    grep -r -n -s -a --color=auto --exclude-dir=\.svn --exclude=\*.{o,la,a,so,obj,so.*,swp} --exclude={cscope.out,cscope.in.out,cscope.po.out} "$*" *
# -r: recursive
# -n: prefix with line number
# -s: suppress error messages
# -a: prcess a binary file
}

git_diff() {
    git diff --no-ext-diff -w "$@" | vim -R -
}

vim_diff_tab() {
    vim -p $(git diff --name-only) -c "tabdo :Gdiff"
}

alias vi="vim"

alias irssi_jienhui='irssi --connect=chat.freenode.net --nick=jienhui --password=3939889'

alias dmesg='dmesg --human'

alias gi='. /home/$USER/my_scripts/git-info.sh'

custom_prompt() {
    PREV_EXIT_CODE="$?"
    CUR_DIR=`pwd`
    CUSTOM_INFO="${COLOR_YELLOW_BOLD}${CUR_DIR}${COLOR_NONE}"
    GIT_BRANCH_NAME=$(__git_ps1 '(%s)')
    CUSTOM_INFO="${CUSTOM_INFO} ${COLOR_BLUE_BOLD}${GIT_BRANCH_NAME}${COLOR_NONE}"
    if [ $PREV_EXIT_CODE -ne 0 ]; then
        PREV_EXIT_CODE_NAME="${PREV_EXIT_CODE}"
        if [ $PREV_EXIT_CODE -gt 128 ]; then
            PREV_EXIT_CODE_SIGNAL=$(( $PREV_EXIT_CODE - 128 ))
            PREV_EXIT_CODE_SIGNAL=$(kill -l $PREV_EXIT_CODE_SIGNAL 2>/dev/null)
            if [ -n "$PREV_EXIT_CODE_SIGNAL" ]; then
                PREV_EXIT_CODE_NAME="${PREV_EXIT_CODE}: SIG${PREV_EXIT_CODE_SIGNAL}"
            fi
        fi
        CUSTOM_INFO="${CUSTOM_INFO} ${COLOR_RED_BOLD}${PREV_EXIT_CODE_NAME}${COLOR_NONE}" 
    fi
    echo -ne "$CUSTOM_INFO\n"
}

export PROMPT_COMMAND="custom_prompt"

# Tmuxinator
export EDITOR=vim

# Powerline
#if [ `which powerline-daemon` ]; then
#    powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    . /usr/share/powerline/bash/powerline.sh
#fi

if [ -x /usr/bin/vimx ]; then
    alias vi='vimx -p'
    alias vim='vimx -p'
fi

alias diffd='diff -qrN $1 $2'

alias fname='find -name'

# Zephyr
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR=/home/ljh/work/zephyr-tools
export PATH=~/.local/bin:"$PATH"

