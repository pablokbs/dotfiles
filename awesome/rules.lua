-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     size_hints_honor = false,
                     --ontop = false,
                     --fullscreen = false,

                     keys = clientkeys,
                     buttons = clientbuttons,
                     
                     maximized_vertical = false,
                     maximized_horizontal = false
                     } },
    { rule = { name="recordMyDesktop" },
      properties = { floating = true } },
    { rule = { name="Gvim" },
      properties = { size_hints_honor = true } },
    { rule = { name="Exe"}, -- Flash full screen
      properties = { floating = true } },
    { rule = { class="DeepinScrot.py" },
      properties = { fullscreen = true,
                     ontop = true } },
    { rule = { class="Tipswindow.py" },
      properties = { floating = true,
                     type = normal } },
    { rule = { class="Pidgin" },
      properties = { floating = false,
                     type = normal,
                     tag = tags[1][1] } },
    { rule = { class="Steam" },
      properties = { border_width = 0, floating = true } },
    { rule = { class="Tegaki-recognize" },
      properties = { border_width = 8,
                     floating = true,
                     focus = function (c) return nil end,
                     buttons = nil } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c)
            and c.class ~= "Tegaki-recognize" then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            --awful.placement.under_mouse(c)
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end

    --if awful.titlebar(c) --[[and awful.layout.get(c.screen) ~= awful.layout.suit.floating]] then
    --    awful.titlebar(c).visible = true
    --end

    -- Arrange everything
    awful.layout.arrange(mouse.screen)
end)

-- Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    local num_tiled = 0
    for _, c in pairs(clients) do
        if not awful.client.floating.get(c) then
            num_tiled = num_tiled + 1
        end
    end
    if layout == "floating" then
        num_tiled = 0
    end

    for _, c in pairs(clients) do
        if num_tiled <= 1 or layout == "max" then
            c.border_width = 0
            beautiful.cur_gap = beautiful.small_gap
        else
            c.border_width = beautiful.border_width
            beautiful.cur_gap = beautiful.orig_gap
        end
        if awful.client.floating.get(c) or layout == "floating" then
            -- Floaters are always on top
            c.size_hints_honor = true
            -- and bordered
            if not c.fullscreen then
                -- and above
                c.above = true
            end
        else
            c.above = false
            c.size_hints_honor = false
        end
    end
  end)
end

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
