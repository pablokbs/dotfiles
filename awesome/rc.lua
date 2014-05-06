-- {{{ License
--
-- Awesome configuration, using awesome 3.4.10 on Ubuntu 11.10
--   * Tony N <tony@git-pull.com>
--
-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- based off Adrian C. <anrxc@sysphere.org>'s rc.lua
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
require("naughty")
-- User libraries
require("vicious") -- ./vicious
require("helpers") -- helpers.lua
-- }}}

-- {{{ Default configuration
altkey = "Mod1"
modkey = "Mod4" -- your windows/apple key

terminal = "xterm"
editor = "vim"

wallpaper_dir = os.getenv("HOME") .. "/Dropbox/wallpapers/" -- grabs a random bg

taglist_numbers = "arabic" -- we support arabic (1,2,3...),
-- arabic, chinese, {east|persian}_arabic, roman, thai, random

cpugraph_enable = true -- show CPU graph
cputext_format = " $1%" -- %1 average cpu, %[2..] every other thread individually

membar_enable = true -- show memory bar
memtext_format = " $1%" -- %1 percentage, %2 used %3 total %4 free

date_format = "%A %d-%m-%Y %k:%M" -- refer to http://en.wikipedia.org/wiki/Date_(Unix) specifiers

networks = {'eno1', 'wlo1', 'enp1s10'} -- Add your devices network interface here netwidget, only show one that works

-- }}}

-- {{{ Variable definitions
local wallpaper_cmd = "find " .. wallpaper_dir .. " -type f -name '*.jpg'  -print0 | shuf -n1 -z | xargs -0 feh --bg-fill"
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell

-- Beautiful theme
--beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/zenburn-custom/theme.lua")

-- Window management layouts
layouts = {
  awful.layout.suit.tile,
  --awful.layout.suit.tile.bottom,
  --awful.layout.suit.tile.top,
  --awful.layout.suit.fair,
  awful.layout.suit.max,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags

-- Taglist numerals
taglist_numbers_langs = { 'arabic', 'chinese', 'traditional_chinese', 'east_arabic', 'persian_arabic', }
taglist_numbers_sets = {
	arabic={ 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	chinese={"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"},
	traditional_chinese={"壹", "貳", "叄", "肆", "伍", "陸", "柒", "捌", "玖", "拾"},
	east_arabic={'١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'}, -- '٠' 0
	persian_arabic={'٠', '١', '٢', '٣', '۴', '۵', '۶', '٧', '٨', '٩'},
	roman={'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'},
	thai={'๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙', '๑๐'},
}
-- }}}

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
      --tags[s] = awful.tag({"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}, s, layouts[1])
      --tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
	if taglist_numbers == 'random' then
		math.randomseed(os.time())
		local taglist = taglist_numbers_sets[taglist_numbers_langs[math.random(table.getn(taglist_numbers_langs))]]
		tags[s] = awful.tag(taglist, s, layouts[1])
	else
		tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
	end
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
--
--
--


wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))


mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))







for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(function(c)
		return awful.widget.tasklist.label.focused(c, s)
	end, mytasklist.buttons)

    mystatusbar = awful.wibox({ position = "top", bg = black, ontop = false,  width = 400, height = 12 })

    mystatusbar.widgets = {
        {   taglist[s],   },
     --   s == screen.count() and systray or nil, -- show tray on last screen
        s == 1 and systray or nil, -- only show tray on first screen
     --   s == 1 and separator or nil, -- only show on first screen
	mytasklist[s],
        ["layout"] = awful.widget.layout.horizontal.leftright
    }


end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
--    awful.key({ modkey,           }, ",",     function () awful.tag.incnmaster( 1)      end),
--    awful.key({ modkey,           }, ".",     function () awful.tag.incnmaster(-1)      end),	
    awful.key({ modkey,		}, ",",		function() awful.screen.focus(1)	 end),
    awful.key({ modkey,		}, ".",		function() awful.screen.focus(2)	 end),
    awful.key({ modkey, "Shift"	}, ",",		function() awful.client.movetotag(tags[client.focus.screen][2])	 end),
    awful.key({ modkey,	"Shift"	}, ".",		function() awful.client.movetotag(tags[client.focus.screen][2])	 end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, 	  }, "n",	function () exec("dmenuclip") end),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey }, "b", function ()
         wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),

    -- Prompt
    awful.key({ },      "F4",     function () exec("dmenu_run -nb black -nf rgb:a0/a0/a0 -sb rgb:00/80/80 -sf black") end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,		  }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "t",      awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift"   }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
           else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

--client.focus = c

-- {{{ Rules
awful.rules.rules = {
    { rule = { }, 
      properties = {	border_width = beautiful.border_width,
      			border_color = beautiful.border_normal,
      			focus = true,
			size_hints_honor = false,
      			keys = clientkeys,
			buttons = clientbuttons
			} },
	{ rule = { class = "ROX-Filer" },   properties = { floating = true } },
	{ rule = { class = "Skype" },   properties = { floating = true } },
	{ rule = { class = "psi" },   properties = { floating = true } },
	{ rule = { class = "Steam" },   properties = { floating = true } },
	{ rule = { class = "Firefox" },   properties = { floating = false } },
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
--    if awful.client.floating.get(c)
--    or awful.layout.get(c.screen) == awful.layout.suit.floating then
--        if   c.titlebar then awful.titlebar.remove(c)
--        else awful.titlebar.add(c, {modkey = modkey}) end
--    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        -- awful.client.setslave(c)

        if  not c.size_hints.program_position and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
       else                          c.above       =  false end
    end
  end)
end
-- }}}

-- require_safe('autorun')
