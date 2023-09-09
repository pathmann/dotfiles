#!/usr/bin/env python

import os
import atexit
from pathlib import Path


HIST_DIR = os.getenv("XDG_CACHE_HOME", (Path.home() / ".cache"))
HIST_FILE = Path(HIST_DIR) / "python_history"
HIST_LEN = 0


def save_history(prev_len, f):
    new_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_len - prev_len, f)

try:
    import readline
except ImportError:
    print("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    
    if HIST_FILE.exists():
        readline.read_history_file(str(HIST_FILE))
        HIST_LEN = readline.get_current_history_length()
    else:
        HIST_FILE.parent.mkdir(750, parents=True, exist_ok=True)
        HIST_FILE.open("w").close()
        
    atexit.register(save_history, HIST_LEN, HIST_FILE)
