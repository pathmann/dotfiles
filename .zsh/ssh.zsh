if [ -n "$SSH_CLIENT" ]; then
  ln -sf ~/.config/htop/htoprc.ssh ~/.config/htop/htoprc
fi

function sshTrap() 
{
  if [ -n "$SSH_CLIENT" ]; then
    ln -sf ~/.config/htop/htoprc.normal ~/.config/htop/htoprc  
  fi
}


trap "sshTrap" EXIT
