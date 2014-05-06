local string = string
local tostring = tostring
local os = os
local capi = {
    mouse = mouse,
    screen = screen
}
local awful = require("awful")
local naughty = require("naughty")
module("daze.widgets.net")

function register(mywidget)
    mywidget:buttons(awful.util.table.join(
    awful.button({ }, 1, 
    function()
        awful.util.spawn_with_shell("/home/spectrum/.config/awesome/daze/widgets/scripts/dzen_network.sh")
    end)
   ))
end

