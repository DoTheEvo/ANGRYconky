# ANGRYconky

*weather not working at the moment, didnt bother to fix yet as yahoo api went off*

Conky derived from [Harmattan](http://zagortenay333.deviantart.com/art/Conky-Harmattan-426662366)

![picture how it looks](http://i.imgur.com/4t19xUE.jpg)

For conky version 1.10+

everything is kept in ~/.config/conky

some lua, some python3

#### installation:
* copy conky folder in to ~/.config/
* make python scrips executable: `chmod +x python_conky_scripts.py`
* change yahoo weather ID number in the main rc file
* run conky on startup with command: `conky -c ~/.config/conky/conkyrc_main`
