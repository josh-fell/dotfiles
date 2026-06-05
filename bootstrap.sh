#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

brew bundle --file="$DOTFILES/Brewfile"

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "linked $dst -> $src"
}

link zsh/.zshrc                  "$HOME/.zshrc"
link starship/starship.toml      "$HOME/.config/starship/starship.toml"
link wezterm/wezterm.lua         "$HOME/.config/wezterm/wezterm.lua"
