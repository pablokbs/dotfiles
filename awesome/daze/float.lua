local pairs = pairs
local awful = require("awful")
local capi = {
    mouse = mouse,
    client = client,
    screen = screen
}
local spawn_under_mouse = true

module("daze.float")

local client = {}

function arrange(arg) 
    client[arg] = {}
    
    capi.client.add_signal("unmanage", function (c)
        for scr, cl in pairs(client[arg]) do
            if cl == c then
                client[arg][scr] = nil
            end
        end
    end)
    
    wspawn = function (c)
        client[arg][capi.mouse.screen] = c
        awful.client.floating.set(c, true)
        if spawn_under_mouse then
			awful.placement.under_mouse(c)
		end
	end
    
    capi.client.add_signal("manage", wspawn)
    awful.util.spawn(arg, false)
end

