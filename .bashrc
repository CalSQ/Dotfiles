# BASH SHELL CONFIG


# Prompt
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '
fastfetch

# Load bash aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
