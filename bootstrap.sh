#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

brew bundle --file="$DOTFILES/Brewfile"

git config --global user.name "Josh Fell"

uv tool install ruff
uv tool install rust-just
uv tool install prek

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "linked $dst -> $src"
}

link zsh/.zshrc                  "$HOME/.zshrc"
link starship/starship.toml      "$HOME/.config/starship/starship.toml"
link wezterm/wezterm.lua         "$HOME/.config/wezterm/wezterm.lua"
