#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export TERM=xterm-256color

function set_proxy()
{
	export http_proxy=http://127.0.0.1:7890
	export https_proxy=$http_proxy
	export ftp_proxy=$http_proxy
	export rsync_proxy=$http_proxy
	export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	export HTTP_PROXY=$http_proxy
	export HTTPS_PROXY=$https_proxy
	export FTP_PROXY=$ftp_proxy
	export RSYNC_PROXY=$rsync_proxy
	export NO_PROXY=$no_proxy
	echo "proxy is started !"
}

function unset_proxy()
{
	unset http_proxy https_proxy ftp_proxy rsync_proxy \
		HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
}

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

# config the powerline 
source ~/.bash-powerline.sh

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

