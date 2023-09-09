if [ -f /usr/bin/python ]; then
  PYMINOR=$(python -c 'import sys; print(sys.version_info.minor)')  
  export PYTHONPATH="$HOME/.local/lib/python3.$PYMINOR/site-packages"
fi

export PYTHONSTARTUP="$HOME/.config/python/startup.py"
