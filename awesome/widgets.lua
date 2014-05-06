-- Separator : between each widget
separator = wibox.widget.imagebox()
separator:set_image(config_dir .. "/theme/separator.png")

-- Left separator adjusts volume when scrolled over
left_separator = wibox.widget.imagebox()
left_separator:set_image(config_dir .. "/theme/separator.png")
left_separator:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("vol.sh mute") end),
    awful.button({ }, 4, function () awful.util.spawn("vol.sh up") end),
    awful.button({ }, 5, function () awful.util.spawn("vol.sh down") end)
))

-- Right separator adjusts brightness when scrolled over
right_separator = wibox.widget.imagebox()
right_separator:set_image(config_dir .. "/theme/separator.png")
right_separator:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.tag.viewnone() end),
    awful.button({ }, 4, function () awful.util.spawn("xbacklight -time 0 + 13") end),
    awful.button({ }, 5, function () awful.util.spawn("xbacklight -time 0 - 1") end)
))

-- Spacer: for fake centering
spacer = wibox.widget.textbox()
spacer:set_text("                                                                                                     ")

timeicon = wibox.widget.imagebox()
timeicon:set_image(config_dir .. "/theme/statusicons/clock.png")

-- Battery
batwidget = wibox.widget.textbox()
battimer = timer({ timeout = 1 })
battimer:connect_signal("timeout", function()
    local status = io.open("/sys/class/power_supply/BAT0/status"):read()
    local perc = io.open("/sys/class/power_supply/BAT0/capacity"):read()
    local symbols = {Discharging = "-", Charging = "+", Full = ""}
    local symbol = symbols[status] or "="
    if status == "Full" then
        batwidget:set_text("")
    else
        batwidget:set_text(string.format("[%s%d%%]", symbol, perc))
    end
end)
battimer:start()

timewidget = wibox.widget.textbox()
timewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        cal = io.popen("cal -3")
        cal_text = "\n" .. cal:read("*all")
        cal_text = string.sub(cal_text, 1, -3)
        awful.util.spawn("notify-send -t 60000 ' ' "
            .. "'" .. os.date("It is %A, %B %e, %Y.\nWeek %W of the year.\nTime zone: UTC%z.\n'"))
    end)
))

mpdwidget = wibox.widget.textbox()
mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("mpc next") end),
    awful.button({ }, 2, function () awful.util.spawn("mpc del 0") end),
    awful.button({ }, 3, function () awful.util.spawn("mpc stop") end)
))

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function()
    timewidget:set_text(os.date("%b ") .. (os.date("%d")+0) .. ', ' .. (os.date("%I")+0) .. os.date(":%M %p"):lower())

    mpdstats = io.popen("mpc -f '[[%artist% - ]%title%]|[%file%]' current")
    mpdwidget:set_text(mpdstats:read("*all"))
    mpdstats:close()
end)
mytimer:start()

-- System tray
--mysystray = wibox.widget.systray()

-- Old unused widgets
--[[ Battery
battwidget = widget({ type = "textbox" })
charging = 1
vicious.register(battwidget, vicious.widgets.bat,
	function (widget, args)
		if args[2] == 0 then return "Battery derped" end
        text = args[3]
        if (args[1] == "↯") then
            return "[|||||]"
        elseif (args[1] == "+") then
            return "[ " .. args[2] .. "% ]"
        end
        return string.format("[%-5s]", text)
	end, 3.14159265357, "BAT0" -- pi
)
--]]

-- Network up/down
--[[
netwidget = widget({ type = "textbox"  })
vicious.register(netwidget, vicious.widgets.net,
	function (widget, args)
		upping = args["{wlan0 up_kb}"]
		downing = args["{wlan0 down_kb}"]
		return string.format("↑%sKiB ↓%sKiB", upping, downing)
	end, 1, "wlan0"
)
--]]
--[[ Volume
volimg = image(config_dir .. "/theme/statusicons/speaker.png")
volimg_muted = image(config_dir .. "/theme/statusicons/speaker_muted.png")

volicon = widget({ type = "imagebox" })
volicon.image = volimg

volwidget = widget({ type = "textbox" })
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(config_dir .. "/vol.sh mute") end),
    awful.button({ }, 2, function () awful.util.spawn("sonata") end),
    awful.button({ }, 4, function () awful.util.spawn(config_dir .. "/vol.sh up") end),
    awful.button({ }, 5, function () awful.util.spawn(config_dir .. "/vol.sh down") end)
))
--]]
-- Populate event-driven widgets with info
--awful.util.spawn(config_dir .. "/vol.sh init")

