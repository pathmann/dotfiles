
alias "rust-cling=evcxr"
alias "gksudo=sudo gksudo gksudo"
alias "gcalctool=LC_NUMERIC=de_DE.UTF-8 gnome-calculator"
alias "yay=yay --save --makepkg $HOME/bin/customizepkg-makepkg.sh"
alias "dotfiles=git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias "grep=nocorrect grep --color=auto"
alias "neovimcfg=cd $HOME/.config/nvim && nvim . ; cd -"
#checkout with: git clone git@github.com:pathmann/dotfiles.git --separate-git-dir=~/.dotfiles ~
#if that fails:
#git clone --separate-git-dir=$HOME/.dotfiles git@github.com:pathmann/dotfiles.git tmpdotfiles
#rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
#rm -r tmpdotfiles

if [ ! -f /usr/bin/delta ]; then
  alias "git=do_git"
fi

if [ -f /usr/bin/eza ]; then
  alias "exa=eza"
  alias "eza=eza -al --icons"
  alias "ls=eza -al"
elif [ -f /usr/bin/exa ]; then
  alias "exa=exa -al --icons"
  alias "ls=exa -al"
else
  alias "ls=ls --color=auto -h -al"
fi

if [ -f /usr/bin/bat ]; then
  alias "cat=bat"
elif [ -f /usr/bin/batcat ]; then
  alias "cat=batcat"
fi

if [ -f /usr/bin/micro ]; then
  alias "nano=micro"
fi

alias "xclip=xclip -sel clip"

#alias "naut=nautilus .&"

if [ -f /usr/bin/zoxide ]; then
  alias "cd=z"
fi

if [[ ! -f /usr/bin/gedit && -f /usr/bin/leafpad ]]; then
  alias "gedit=leafpad"
fi

if [ -f /usr/bin/fuck ]; then
  eval $(thefuck --alias)
fi

# Reveal the real command executed, credits to https://dev.to/equiman/reveal-the-command-behind-an-alias-with-zsh-4d96
local cmd_alias=""

# Reveal Executed Alias
alias_for() {
  [[ $1 =~ '[[:punct:]]' ]] && return
  local search=${1}
  local found="$( alias $search )"
  if [[ -n $found ]]; then
    found=${found//\\//} # Replace backslash with slash
    found=${found%\'} # Remove end single quote
    found=${found#"$search="} # Remove alias name
    found=${found#"'"} # Remove first single quote
    echo "${found} ${2}" | xargs # Return found value (with parameters)
  else
    echo ""
  fi
}

expand_command_line() {
  first=$(echo "$1" | awk '{print $1;}')
  rest=$(echo ${${1}/"${first}"/})

  if [[ -n "${first//-//}" ]]; then # is not hypen
    cmd_alias="$(alias_for "${first}" "${rest:1}")" # Check if there's an alias for the command
    if [[ -n $cmd_alias ]] && [[ "${cmd_alias:0:1}" != "." ]]; then # If there was and not start with dot
      echo "${T_GREEN}❯ ${T_YELLOW}${cmd_alias}${F_RESET}" # Print it
    fi
  fi
}

pre_alias_validation() {
  [[ $# -eq 0 ]] && return                    # If there's no input, return. Else...
  expand_command_line "$@"
}

autoload -U add-zsh-hook
add-zsh-hook preexec pre_alias_validation 
