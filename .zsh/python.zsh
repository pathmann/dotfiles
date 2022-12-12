if [ -f /usr/bin/python ]; then
  PYMINOR=$(python -c 'import sys; print(sys.version_info.minor)')  
  export PYTHONPATH="/home/thomas/.local/lib/python3.$PYMINOR/site-packages"
fi

export PYTHONSTARTUP="/home/thomas/.pythonstartup"
