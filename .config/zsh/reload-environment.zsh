if [ -n "$TMUX" ]; then                                                                               
  function refresh {                                                                                
    export $(tmux show-environment | grep "^WAYLAND_DISPLAY")                                       
    export $(tmux show-environment | grep "^XDG_CURRENT_DESKTOP")
	export $(tmux show-environment | grep "^HYPRLAND_INSTANCE_SIGNATURE")                                             
                                       
  }                                                                                                 
else                                                                                                  
  function refresh { }                                                                              
fi
