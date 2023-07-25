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

#command -v git >/dev/null || echo "Install git to run this script" && exit 1
#command -v curl >/dev/null || echo "Install curl to run this script" && exit 1

for option in "$@"; do
  case $option in
    alacritty)
      [ ! -d "$HOME/.config/alacritty" ] && mkdir -p "$HOME/.config/alacritty"
      link "$PWD/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
      ;;
    zsh)
      [ ! -d "$HOME/.config/zsh" ] && mkdir -p "$HOME/.config/zsh"
      link "$PWD/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"
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
      ;;
    sway)
      [ ! -d "$HOME/.config/sway" ] && mkdir -p "$HOME/.config/sway"
      link "$PWD/sway/config" "$HOME/.config/sway/config"
      link "$PWD/sway/lock.sh" "$HOME/.config/sway/lock.sh"
      [ -e "$HOME/.config/zsh/variables" ] && link \
        "$HOME/.config/zsh/variables" "$HOME/.config/sway/env"
      echo "output * bg /usr/share/backgrounds/Sway_Wallpaper_Blue_1920x1080.png fill" \
        >> $HOME/.config/sway/wallpapers
      echo "### Output Configuration
      # get outputs by running: swaymsg -t get_outputs " \
        >> $HOME/.config/sway/monitors
      ;;
    waybar)
      [ ! -d "$HOME/.config/waybar" ] && mkdir -p "$HOME/.config/waybar"
      link "$PWD/waybar/config" "$HOME/.config/waybar/config"
      link "$PWD/waybar/style.css" "$HOME/.config/waybar/style.css"
      ;;
    *)
      printf '\033[0;31mno config file found for "%s"\033[0m\n' "$option"
      help
      exit 1
      ;;
  esac
  printf '\033[0;32mDeployed configs for %s\033[0m\n' "$option"
done
