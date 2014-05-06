require("beautiful")

-- {{{ Mouse bindings
root.buttons(
    awful.util.table.join(
        awful.button({ }, 1, function () mymainmenu:hide() end),
        awful.button({ }, 3, function () mymainmenu:toggle() end)
    )
)
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Tag movement
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    --awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    
    -- Window selection
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05)       end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1)        end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1)           end),
    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact(0.05)        end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1)        end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1)           end),
    awful.key({ modkey,           }, "m", function () awful.tag.setmwfact(0.5)        end),
    --awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    --awful.key({ modkey,           }, "Tab",
    --    function ()
    --        awful.client.focus.history.previous()
    --        if client.focus then
    --            client.focus:raise()
    --        end
    --    end),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", function ()
        --awful.util.spawn_with_shell("killall compton")
        awesome.restart()
    end),
    awful.key({ modkey, "Shift", "Control" }, "Escape", awesome.quit),

    -- Change layout
    awful.key({ modkey,                    }, "F1",    function () awful.layout.set(awful.layout.suit.tile) end),
    awful.key({ modkey, "Shift",           }, "F1",    function () awful.layout.set(awful.layout.suit.tile.left) end),
    awful.key({ modkey,          "Control" }, "F1",    function () awful.layout.set(awful.layout.suit.tile.bottom) end),
    awful.key({ modkey, "Shift", "Control" }, "F1",    function () awful.layout.set(awful.layout.suit.tile.top) end),
    awful.key({ modkey,                    }, "F2",    function () awful.layout.set(awful.layout.suit.max) end),
    awful.key({ modkey, "Shift",           }, "F2",    function () awful.layout.set(awful.layout.suit.max.fullscreen) end),
    awful.key({ modkey,                    }, "F3",    function () awful.layout.set(awful.layout.suit.fair.horizontal) end),
    awful.key({ modkey, "Shift",           }, "F3",    function () awful.layout.set(awful.layout.suit.fair) end),
    awful.key({ modkey,                    }, "F4",    function () awful.layout.set(awful.layout.suit.spiral) end),
    awful.key({ modkey, "Shift",           }, "F4",    function () awful.layout.set(awful.layout.suit.spiral.dwindle) end),
    awful.key({ modkey,                    }, "F5",    function () awful.layout.set(awful.layout.suit.magnifier) end),
    awful.key({ modkey,                    }, "grave", function () awful.layout.set(awful.layout.suit.floating) end),

    --awful.key({ modkey, "Control"          }, "n", awful.client.restore),
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
		awful.layout.arrange(mouse.screen)
    end),

    -- Change gap
    awful.key({ modkey }, "g", function ()
        beautiful.cur_gap = beautiful.orig_gap - beautiful.cur_gap
    end),

    -- Make everything ultra minimal:
    awful.key({ modkey }, "Escape", function ()
        awful.util.spawn_with_shell("killall conky")
        awful.util.spawn_with_shell("xsetroot -solid black")
        awful.util.spawn_with_shell("killall compton")
        beautiful.border_width = 0
        beautiful.orig_gap = 0
        beautiful.small_gap = 0
        beautiful.cur_gap = 0
    end),

    -- dmenu prompt
    awful.key({ modkey,           }, "p",
        function () awful.util.spawn("dmenu_run -fn 'Sazanami Gothic-8' " ..
                                      --"-b " ..
                                      --"-l 9 " ..
                                      "-i " ..
                                      "-p 'wish?' " ..
                                      "-nb '" .. beautiful.dmenu_bg_normal .. "' " ..
                                      "-nf '" .. beautiful.dmenu_fg_normal .. "' " ..
                                      "-sb '" .. beautiful.dmenu_bg_focus .. "' " ..
                                      "-sf '" .. beautiful.dmenu_fg_focus .. "'")
        end),
    
    -- Applications
    awful.key({ modkey, "Shift"            }, "Return", function () awful.util.spawn(terminal) end ),
    awful.key({ modkey, "Shift", "Control" }, "Return", function () awful.util.spawn("gnome-terminal") end ),
    awful.key({ modkey, "Shift"            }, "w",      function () awful.util.spawn(browser) end),
    awful.key({ modkey, "Shift", "Control" }, "w",      function () awful.util.spawn("chromium --incognito") end),
    awful.key({ modkey, "Shift"            }, "f",      function () awful.util.spawn("thunar") end),
    awful.key({ modkey, "Shift"            }, "a",      function () awful.util.spawn("arandr") end),
    awful.key({ modkey, "Shift"            }, "x",      function () awful.util.spawn("xkill") end),
    awful.key({ modkey,                    }, "s",      function () awful.util.spawn("scrotshot.sh") end),
    awful.key({ modkey, "Shift"            }, "i",      function () awful.util.spawn(terminal .. " -e wicd-curses") end),
    awful.key({ modkey, "Shift"            }, "n",      function () awful.util.spawn(terminal .. " -e ncmpcpp") end),
    awful.key({ modkey, "Shift"            }, "m",      function () awful.util.spawn(terminal .. " -e htop") end),
    awful.key({ modkey, "Shift"            }, "e",      function () awful.util.spawn("gvim") end),
    
    -- Utils
    awful.key({ }, "XF86PowerOff",          function () awful.util.spawn_with_shell("xset dpms force off") end),
    awful.key({ }, "XF86Suspend",           function () awful.util.spawn("systemctl hibernate") end),
    awful.key({ }, "XF86MonBrightnessUp",   function () awful.util.spawn(config_dir .. "/brig.sh +") end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn(config_dir .. "/brig.sh -") end),
    awful.key({ }, "XF86AudioMute",         function () awful.util.spawn(config_dir .. "/vol.sh mute") end),
    awful.key({ }, "XF86AudioRaiseVolume",  function () awful.util.spawn(config_dir .. "/vol.sh up") end),
    awful.key({ }, "XF86AudioLowerVolume",  function () awful.util.spawn(config_dir .. "/vol.sh down") end),
    awful.key({ }, "Help",                  function () awful.util.spawn(config_dir .. "/lock.sh") end),
    awful.key({ }, "XF86HomePage",          function () awful.util.spawn("xcalib -clear") end),

    -- ibus
    awful.key({ modkey,          "Control" }, "e",      function () awful.util.spawn("ibus engine xkb:ca:eng:eng") end),
    awful.key({ modkey,          "Control" }, "d",      function () awful.util.spawn("ibus engine xkb:us:dvorak:eng") end)
)

local fm = 48
clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift" }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey },          "c",      function (c) awful.placement.centered(c)      end),
    awful.key({ modkey },          "f",      awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift" }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey },          "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey },          "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey },          "t",      function (c) c.ontop = not c.ontop            end),
    --awful.key({ modkey }, "n",
    --    function (c)
    --        c.border_width = beautiful.border_width - c.border_width
    --        awful.titlebar(c).visible = not awful.titlebar(c).visible
    --        awful.layout.arrange(mous.screen)
    --    end
    --),

    -- Window movement
    awful.key({ modkey }, "KP_Down",  function () awful.client.moveresize(  0,  fm,   0,   0) end),
    awful.key({ modkey }, "KP_Up",    function () awful.client.moveresize(  0, -fm,   0,   0) end),
    awful.key({ modkey }, "KP_Left",  function () awful.client.moveresize(-fm,   0,   0,   0) end),
    awful.key({ modkey }, "KP_Right", function () awful.client.moveresize( fm,   0,   0,   0) end),
    awful.key({ modkey, "Shift" }, "KP_Down",  function () awful.client.moveresize(  0,   0,   0,  fm) end),
    awful.key({ modkey, "Shift" }, "KP_Up",    function () awful.client.moveresize(  0,   0,   0, -fm) end),
    awful.key({ modkey, "Shift" }, "KP_Left",  function () awful.client.moveresize(  0,   0, -fm,   0) end),
    awful.key({ modkey, "Shift" }, "KP_Right", function () awful.client.moveresize(  0,   0,  fm,   0) end),
    awful.key({ modkey, "Control" }, "KP_Down",  function () awful.client.moveresize(  0,   1,   0,   0) end),
    awful.key({ modkey, "Control" }, "KP_Up",    function () awful.client.moveresize(  0,  -1,   0,   0) end),
    awful.key({ modkey, "Control" }, "KP_Left",  function () awful.client.moveresize( -1,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "KP_Right", function () awful.client.moveresize(  1,   0,   0,   0) end),
    awful.key({ modkey, "Control", "Shift" }, "KP_Down",  function () awful.client.moveresize(  0,   0,   0,  1) end),
    awful.key({ modkey, "Control", "Shift" }, "KP_Up",    function () awful.client.moveresize(  0,   0,   0, -1) end),
    awful.key({ modkey, "Control", "Shift" }, "KP_Left",  function () awful.client.moveresize(  0,   0, -1,   0) end),
    awful.key({ modkey, "Control", "Shift" }, "KP_Right", function () awful.client.moveresize(  0,   0,  1,   0) end)
    --awful.key({ modkey, }, "x",      function (c) c.border_width = 1-c.border_width end),
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

local tagkeys = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for k in pairs(tagkeys) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. k + 9,
                function ()
                    local screen = mouse.screen
                    if tags[screen][k] then
                        awful.tag.viewonly(tags[screen][k])
                    end
                end),
        awful.key({ modkey, "Control" }, "#" .. k + 9,
                function ()
                    local screen = mouse.screen
                    if tags[screen][k] then
                        awful.tag.viewtoggle(tags[screen][k])
                    end
                end),
        awful.key({ modkey, "Shift" }, "#" .. k + 9,
                function ()
                    if client.focus and tags[client.focus.screen][k] then
                        awful.client.movetotag(tags[client.focus.screen][k])
                        --awful.tag.viewonly(t)
                    end
                end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. k + 9,
                function ()
                    if client.focus and tags[client.focus.screen][k] then
                        awful.client.toggletag(tags[client.focus.screen][k])
                    end
                end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, function (c) awful.mouse.client.resize(c) end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
