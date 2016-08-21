if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$PROJECT_DIR/Python
    source /usr/bin/virtualenvwrapper.sh
fi

