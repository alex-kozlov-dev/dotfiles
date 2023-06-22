export PATH=$PATH:$HOME/bin:/usr/local/sbin

export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  z
  # thefuck
  # zsh-autosuggestions
  autoupdate
  nvm
)

# autoload -Uz compinit
# compinit
# zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

export NVM_AUTOLOAD=1

source $ZSH/oh-my-zsh.sh

DEFAULT_USER=`whoami`

export EDITOR="micro"
export VISUAL=$EDITOR
export LANG=en_US

# eval "$(thefuck --alias)"

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
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# pure prompt
# fpath+=("$ZSH_CUSTOM/prompt/pure")
# autoload -U promptinit; promptinit
# prompt pure

# init pyenv
export PYENV_ROOT=$HOME/.pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pass pyenv's python to pipenv
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

# source private stuff
setopt NULL_GLOB
for f in $HOME/.dotfiles/zsh/private/*.sh; do source $f; done
unsetopt NULL_GLOB

# init fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# kubectl krew
export PATH="${PATH}:${HOME}/.krew/bin"

# custom bins
export PATH=$PATH:$DOTFILES/zsh/bin
export PATH=$PATH:$DOTFILES/zsh/private/bin

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Android Studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# kill autocomplete
# zstyle ':completion:*:*:kill:*' menu yes select
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:*:kill:*:processes' command 'ps xo pid,user:10,cmd | ack-grep -v "sshd:|-zsh$"'


# cloudconvert
export CLOUDCONVERT_API_KEY=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDA4NjlhY2VhOTI0ZTlhYjE5MWVhYmM4MDBkZTg4ZGY5NWJlMDQwYzc1NGNkZDBkZjhkYWQxYmEwMGExNzc2OTIzYmRmNjgzOTk2ZmJmMjYiLCJpYXQiOjE2NTIwODIyMTMuNjAwMDc1LCJuYmYiOjE2NTIwODIyMTMuNjAwMDc3LCJleHAiOjQ4MDc3NTU4MTMuNTg2Nzk0LCJzdWIiOiI1NzgwMTQxMCIsInNjb3BlcyI6WyJ0YXNrLnJlYWQiLCJ0YXNrLndyaXRlIiwid2ViaG9vay5yZWFkIiwid2ViaG9vay53cml0ZSIsInByZXNldC5yZWFkIiwicHJlc2V0LndyaXRlIl19.ZwmS5llcWjILlFo-VCyS9AWGanTmnVmEDDdtUiLPs15aUzzQrnESCaauwNPhm1eup9nNF0AkFfJYtIVD49zS-SKMbseDd9awEIKNnG4T3foW1Y_KZgj0iNIrtggwFVi1tisg1mwz6_QZzJ6QII5uAZyA2jRuoiRJ6EY2hfALjdJTb6jFwh7owy-XcnxvfGWIWhLVjPcTrkftIqw84QS_G2eX-nc-lUgiaYXT81ej7mfgu0cuehPRdgmgzXbVwEpNokYxyAJHcR09y9P9vF5Bzl4duL1Qz82pYpgKWqNRBmkrH23FvJIH4QZXBmC3VydisYpzy6H9fC34IQHYrauvkS840eR9oW3z7Drt7I4nOcco7nax2Zns1E7ydtRbiHZMDLFh3gA7Q0Tg2NxXJYCQ7UGqddOIyJPYNf_zvp3AfRZUh9XhljFUMkFVyWiom4WDeu_vL5RVOJli-imdJoIGK6c5dWo9yhx-_SIzKMY_iLa9F5So_ro-1d1NJzuSpG3D4bkDBFAeVEGBzof5p6kK5kc4BmdvSlf7YoUt-T8Tz_oRZRKILY7Feselns-X2DMemFRuvlmNjBNKDftebAVkt25cG5x-544nI7U60xmmRuJqtgw1pUR0F0g1y4-PUn0J2iwfz3Dc8Fnk4ACRDcNUs6zpoxceiGoi11pHisWAZAw
