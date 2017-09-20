#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export LC_ALL=en_US.UTF-8
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias omxplayer="omxplayer -r -o local"
