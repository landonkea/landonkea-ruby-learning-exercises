#!/bin/bash

set -e

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
    build-essential \
    rustc \
    libssl-dev \
    libyaml-dev \
    zlib1g-dev \
    libgmp-dev

curl https://mise.run | sh

echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

export PATH="$HOME/.local/bin:$PATH"
eval "$($HOME/.local/bin/mise activate bash)"

which mise

mise use -g ruby@3
ruby --version

gem install rails
rails --version

mise use -g node@26
node -v
npm -v
