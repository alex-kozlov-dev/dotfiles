#!/usr/bin/env bash

eval "$(pyenv init -)"
pyenv install 3.7.6
pyenv global 3.7.6
pip install -U pipenv
