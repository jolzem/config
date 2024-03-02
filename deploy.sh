#!/bin/sh

help() {
  printf 'Choose one or more options from the following list\nto add as an argument to the script:\n'
  grep -P '^\s+[a-z\-]+\)' "$0" | sed 's/)//' | xargs printf ' - %s\n'
  exit 0
}

link() {
  [ -e "$2" ] && printf 'found existing file %s\n' "$2" && rm -i "$2"
  ln -s "$1" "$2" 2>/dev/null
}

[ $# -eq 0 ] && help

command -v git >/dev/null || (echo "Install git to run this script" && exit 1)
command -v curl >/dev/null || (echo "Install curl to run this script" && exit 1)

for option in "$@"; do
  case $option in
    alacritty)
      [ ! -d "$HOME/.config/alacritty" ] && mkdir -p "$HOME/.config/alacritty"
      link "$PWD/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
      ;;
    zsh)
      [ ! -d "$HOME/.config/zsh" ] && mkdir -p "$HOME/.config/zsh"
      link "$PWD/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"
      link "$PWD/zsh/aliases" "$HOME/.config/zsh/aliases"
      link "$PWD/zsh/variables" "$HOME/.config/zsh/variables"
      curl -fLo $HOME/.config/zsh/zsh-autosuggestions.zsh --create-dirs \
        https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/zsh-syntax-highlighting
      git clone https://github.com/romkatv/gitstatus.git $HOME/.config/zsh/gitstatus
      ;;
    nvim)
      [ ! -d "$HOME/.config/nvim" ] && mkdir -p "$HOME/.config/nvim"
      link "$PWD/nvim/init.vim" "$HOME/.config/nvim/init.vim"
      sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      ;;
    git)
      [ ! -d "$HOME/.config/git" ] && mkdir -p "$HOME/.config/git"
      link "$PWD/git/config" "$HOME/.config/git/config"
      command -v gh>/dev/null && gh auth login
      ;;
    user-dirs)
      link "$PWD/user-dirs/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
      xdg-user-dirs-update
      ;;
    packages)
      command -v yay >/dev/null || (echo "Install yay to install packages" && exit 1)
      cat packages/pkgs | yay -S -
      ;;
    librewolf)
      printf 'Paste the path of the Root Directory of your default profile\n'
      librewolf about:profiles
      read -r profile
      link "$PWD/librewolf/user.js" "$profile/user.js"
      ;;
    help)
      help
      ;;
    *)
      printf '\033[0;31mno config file found for "%s"\033[0m\n' "$option"
      help
      exit 1
      ;;
  esac
  printf '\033[0;32mDeployed configs for %s\033[0m\n' "$option"
done
