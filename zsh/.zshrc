autoload -Uz promptinit
promptinit

bindkey -e

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3;5~" backward-kill-word

setopt histignorealldups sharehistory

HISTSIZE=5000
SAVEHIST=5000
HISTFILE=$HOME/.config/zsh/zsh_history

# Modern completion system
autoload -Uz compinit
compinit -d ~/.cache/zsh/ > /dev/null 2>&1
_comp_options+=(globdots)  # include hidden files

autoload -U colors && colors

source /etc/zsh/zshenv
source $HOME/.config/zsh/aliases
source $HOME/.config/zsh/zsh-autosuggestions.zsh
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/gitstatus/gitstatus.prompt.zsh
