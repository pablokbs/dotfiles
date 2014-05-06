--require("menu")
--require("wibox")
--require("widgets")

mywibox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    --awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    --awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function () awful.util.spawn(config_dir .. "/vol.sh up") end),
    awful.button({ }, 5, function () awful.util.spawn(config_dir .. "/vol.sh down") end)
)
mytasklist = {}

-- Create for each screen
for s = 1, screen.count() do
    if s == 1 then
        -- Main wibox
        mywibox[s] = awful.wibox({ position = "top", screen = s })
        mywibox[s].height = 16

        -- Taglist
        mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(left_separator)
        left_layout:add(mytaglist[s])
        left_layout:add(separator)

        local center_layout = wibox.layout.fixed.horizontal()
        mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, mytasklist.buttons)
        center_layout:add(mytasklist[s])

        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(mpdwidget)
        right_layout:add(separator)
        right_layout:add(batwidget)
        right_layout:add(separator)
        right_layout:add(timewidget)
        right_layout:add(separator)
        right_layout:add(wibox.widget.systray())
        right_layout:add(right_separator)

        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_second(center_layout)
        layout:set_right(right_layout)

        mywibox[s]:set_widget(layout)
    else
        --[[ subordinate screens
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(separator)
        left_layout:add(mytaglist[s])
        left_layout:add(separator)

        local center_layout = wibox.layout.fixed.horizontal()
        mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, mytasklist.buttons)
        center_layout:add(mytasklist[s])

        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(timewidget)
        right_layout:add(separator)

        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_second(center_layout)
        layout:set_right(right_layout)

        mywibox[s]:set_widget(layout)
        ]]-- GET NOTHING!!
    end
end
