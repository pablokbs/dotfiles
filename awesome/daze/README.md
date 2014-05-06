daze
====

a module for awesome that handles custom tiling and tooltip widgets

instructions
=============

clone the repo

    git clone git://github.com/speccy/daze

additions to rc.lua
===================
require the module (at the top of rc.lua)

    require("daze") 

put this after your tags
    
    --set the layout
    awful.layout.set(daze.layout.tile, tags[1][1]) 
    --set master window width in percentage
    awful.tag.setmwfact(0.7, tags[1][1])
    --set number of column windows
    awful.tag.setncol(1, tags[1][1])

where x and y tags[x][y] are the workspace and screen you want the layout to work on, respectively

additions to theme.lua
======================
    --set the spacing between tiled windows to 20px
    theme.useless_gap_width = "20"
    --set the height of the lowest window of the second column to 72; setting to zero makes all the slave windows the same height
    theme.lower_window_height = "72"
    --set your vertical resolution
    theme.vertical_resolution = "1080"
    --set the extra vertical spacing to 8px
    theme.vertical_border = "8"
    --set the extra outermost spacing to 18px
    theme.outer_padding = "18"


