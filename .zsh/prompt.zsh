autoload -Uz promptinit
promptinit;

HOSTNAME=${hostname}
if [[ "$HOSTNAME" == "heisenberg" ]]; then
    prompt gentoo;
else
prompt_gentoo_setup () {
prompt_gentoo_prompt=${1:-'blue'}
prompt_gentoo_user=${2:-'green'}
prompt_gentoo_root=${3:-'red'}

if [ "$USER" = 'root' ]
then
base_prompt="%B%F{$prompt_gentoo_root}%m%k "
else
base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
fi
post_prompt="%b%f%k"

#setopt noxtrace localoptions

path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
PS1="$base_prompt$path_prompt %# $post_prompt"
PS2="$base_prompt$path_prompt %_> $post_prompt"
PS3="$base_prompt$path_prompt ?# $post_prompt"
}

prompt_gentoo_setup "$@"
fi
#prompt adam1

autoload -Uz vcs_info

#to set the guake tab title
aspreexec() {
    echo -n '\e]0;'
    echo -nE "$1"
    print -nP '  (%~)'
    echo -n '\a'
}

function title {
  if [[ "$DISABLE_AUTO_TITLE" == "true" ]] || [[ "$EMACS" == *term* ]]; then
    return
  fi
  if [[ "$TERM" == screen* ]]; then
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
}

function precmd {
  vcs_info
  #CURPATH=$(pwd | sed -e "s,^$HOME,~,")
  #CURPATH=${CURPATH:t}
  #title "%15<..<%~%<<" "%n@%m: ${CURPATH}"
  title "%15<..<%~%<<" "%n@%m: %~"
}

# This helps with screen especially
function preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  title "$CMD" "%100>...>$2%<<"
}
