alias "exa=exa -al"
alias "rust-cling=evcxr"
alias "gksudo=sudo gksudo gksudo"
alias "gcalctool=LC_NUMERIC=de_DE.UTF-8 gnome-calculator"
alias "yay=yay --save --makepkg $HOME/bin/customizepkg-makepkg.sh"
alias "dotfiles=git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
#checkout with: git clone git@github.com:pathmann/dotfiles.git --separate-git-dir=~/.dotfiles ~
#if that fails:
#git clone --separate-git-dir=$HOME/.dotfiles git@github.com:pathmann/dotfiles.git tmpdotfiles
#rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
#rm -r tmpdotfiles

if [ ! -f /usr/bin/delta ]; then
  alias "git=do_git"
fi

if [ -f /usr/bin/exa ]; then
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

alias "naut=nautilus .&"

if [ -f /usr/bin/zoxide ]; then
  alias "cd=z"
fi
