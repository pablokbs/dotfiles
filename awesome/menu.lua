local myappsmenu = {
    { "web", browser },
    { "files", "pcmanfm" },
    { "office", "libreoffice" },
    { "sublime text", "subl" }
}

local myutilsmenu = {
    { "reset", "xcalib -clear" },
    { "invert", "xcalib -invert -alter" },
    { "darken", "xcalib -contrast 80 -alter" },
    { "brighten", "xcalib -brightness 15 -alter" },
    { "ashen", function ()
        awful.util.spawn("xcalib -contrast 50 -alter")
        awful.util.spawn("xcalib -brightness 15 -alter")
    end },
    { "1 red", "xcalib -red 1.0 99.0 1.0 -alter" },
    { "1 green", "xcalib -green 1.0 99.0 1.0 -alter" },
    { "1 blue", "xcalib -blue 1.0 99.0 1.0 -alter" },
    { "0 red", "xcalib -red 1.0 0.0 1.0 -alter" },
    { "0 green", "xcalib -green 1.0 0.0 1.0 -alter" },
    { "0 blue", "xcalib -blue 1.0 0.0 1.0 -alter" },
    { "only red", function ()
        awful.util.spawn("xcalib -green 1.0 0.0 1.0 -alter")
        awful.util.spawn("xcalib -blue 1.0 0.0 1.0 -alter")
    end },
    { "only green", function ()
        awful.util.spawn("xcalib -red 1.0 0.0 1.0 -alter")
        awful.util.spawn("xcalib -blue 1.0 0.0 1.0 -alter")
    end },
    { "only blue", function ()
        awful.util.spawn("xcalib -red 1.0 0.0 1.0 -alter")
        awful.util.spawn("xcalib -green 1.0 0.0 1.0 -alter")
    end },
    { "don't hack me", function ()
        awful.util.spawn("xcalib -red 1 0 30 -alter")
        awful.util.spawn("xcalib -blue 1 0 30 -alter")
    end },
    { "whiten", function()
        awful.util.spawn("xcalib -red 1.0 99.0 1.0 -alter")
        awful.util.spawn("xcalib -green 1.0 99.0 1.0 -alter")
        awful.util.spawn("xcalib -blue 1.0 99.0 1.0 -alter")
    end }

}

local dangermenu = {
    { "logout", awesome.quit },
    { "hibernate", "systemctl hibernate" },
    { "restart", "systemctl reboot" },
    { "shutdown", "systemctl poweroff" }
}

mymainmenu = awful.menu({ items = {
    { "screen", myutilsmenu },
    { "terminal", terminal },
    { "reload", awesome.restart },
    { "danger", dangermenu },
}})
