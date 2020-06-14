export PATH=$PATH:$HOME/bin:/usr/local/sbin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
	z
	git
	docker
	thefuck
	zsh-interactive-cd
	zsh-autosuggestions
  autoupdate
)

autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

DEFAULT_USER=`whoami`

export EDITOR="micro"
export VISUAL=$EDITOR
export LANG=en_US

eval "$(thefuck --alias)"

function killport () {
	kill -9 $(lsof -ti tcp:$1)
}

function hg () {
	history -E | grep "$*"
}

function gitrecent () {
	local num="${1:-10}"
	git reflog |
    egrep -io "moving from ([^[:space:]]+)" |
    awk '{ print $3 }' | # extract 3rd column
    awk ' !x[$0]++' | # Removes duplicates.  See http://stackoverflow.com/questions/11532157
    egrep -v '^[a-f0-9]{40}$' | # remove hash results
    while read line; do # verify existence
      ([[ $CHECK_EXISTENCE = '0' ]] || git rev-parse --verify "$line" &>/dev/null) && echo "$line"
    done |
    head -n "$num"
}

# init nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# pure prompt
fpath+=("$ZSH_CUSTOM/prompt/pure")
autoload -U promptinit; promptinit
prompt pure

# init pyenv
eval "$(pyenv init -)"

# pass pyenv's python to pipenv
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

# source private stuff
setopt NULL_GLOB
for f in $HOME/.dotfiles/zsh/private/*.sh; do source $f; done
unsetopt NULL_GLOB