if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    source /usr/bin/virtualenvwrapper.sh
elif [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]; then
	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$PROJECT_DIR/Python
