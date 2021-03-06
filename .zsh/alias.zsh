alias "ls=ls --color=auto -h -al"
alias "gksudo=sudo gksudo gksudo"
alias "gcalctool=LC_NUMERIC=de_DE.UTF-8 gnome-calculator"
alias "yay=yay --save --makepkg $HOME/bin/customizepkg-makepkg.sh"
alias "dotfiles=git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
#checkout with: git clone git@github.com:pathmann/dotfiles.git --separate-git-dir=~/.dotfiles ~
#if that fails:
#git clone --separate-git-dir=$HOME/.dotfiles git@github.com:pathmann/dotfiles.git tmpdotfiles
#rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
#rm -r tmpdotfiles
alias "git=do_git"
