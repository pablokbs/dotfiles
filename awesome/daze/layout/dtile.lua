local ipairs = ipairs
local tonumber = tonumber
local beautiful = require("beautiful")
local awful = require("awful")
local math = math

--  combinations that work well: ugap = 15 tb = -2
--                               ugap = 21 tb = -3
--                               ugap = 10 tb = 2

module("daze.layout.dtile")

name = "dtile"
function arrange(z)
   
    local ugap = tonumber(beautiful.useless_gap_width)
    if ugap == nil then
        ugap = 0
    end
    
    local lower_window_height = tonumber(beautiful.lower_window_height)
    if lower_window_height == nil then
        lower_window_height = 0
    end

    local vertical_resolution = tonumber(beautiful.vertical_resolution)
    if vertical_resolution == nil then
        vertical_resolution = 1080 --assumes vertical resolution is 1080
    end

    local tb_border = tonumber(beautiful.vertical_border)
    if tb_border == nil then
        tb_border = 0
    end

    local cp = tonumber(beautiful.outer_padding)
    if cp == nil then
        cp = 0
    end

    -- screen area
    local wa = z.workarea
    local cls = z.clients
    
    -- main column width
    local t = awful.tag.selected(z.screen)
    local mwfact = awful.tag.getmwfact(t)

    -- overlap if ncol = 1
    local overlap_main = awful.tag.getncol(t)
    
    -- main column
    if #cls > 0 then
        local c = cls[#cls]
        local g = {}
        
        wa.height = wa.height - cp*2
        wa.width = wa.width - cp*2
        wa.x = wa.x + cp
        wa.y = wa.y + cp

        local mwidth = math.floor(wa.width * mwfact)
        local swidth = wa.width - mwidth

        g.width = mwidth
        g.height = wa.height
        g.x = wa.x
        g.y = wa.y
        
        if ugap > 0 then
            g.width = g.width - ugap
            g.height = g.height - 2 * ugap + 2*tb_border
            g.x = g.x + ugap
            g.y = g.y + ugap - tb_border

        end
        if #cls == 1 then
            g.width = wa.width - 2 * ugap
        else
            g.width = mwidth - ugap
        end
        c:geometry(g)
       
        local lwh = lower_window_height

        -- slave client stacking
        if #cls > 1 then
            local sheight = math.floor(wa.height / (#cls -1))
            if lwh == 0 then
                for i = (#cls - 1),1,-1 do
                    c = cls[i]
                    g = {}
                    g.width = swidth
                    if i == (#cls - 1) then
                        g.height = wa.height - (#cls - 2) * sheight
                    else
                        g.height = sheight
                    end
                    g.x = wa.x + mwidth
                    g.y = wa.y + (i - 1) * sheight
                    if ugap > 0 then
                        g.width = g.width - 2 * ugap
                        if i == 1 then
                            g.height = g.height - 2 * ugap
                            g.y = g.y + ugap
                        else
                            g.height = g.height - ugap
                        end
                        g.x = g.x + ugap
                    end
                    c:geometry(g)
                end
            else
                for i = (#cls - 1),1,-1 do
                    local snheight = math.floor((wa.height - 2*(ugap - tb_border) - lwh) / (#cls - 2))
                    c = cls[i]
                    g = {}
                    g.width = swidth
                    if i == (#cls - 1) then
                        g.height = wa.height - (#cls - 2) * snheight
                    else
                        g.height = snheight
                    end
                    g.x = wa.x + mwidth
                    g.y = wa.y + (i - 1) * snheight
                    if ugap > 0 then
                        g.width = g.width - 2 * ugap
                        if (i == (#cls - 1)) then
                          g.height = lwh
                          g.y = vertical_resolution - lwh - ugap + tb_border - cp
                        --g.y = wa.y +  ugap * (i + 2) + snheight*(#cls - 2) - tb_border - lwh 
                        elseif i == 1 then
                            g.height = snheight - ugap
                            g.y = wa.y + ugap - tb_border
--                            g.y = wa.y +  ugap * i + snheight*(#cls - 3) - tb_border
                        else
                            g.height = snheight - ugap
                            g.y = g.y - tb_border + ugap
--                            g.y = g.y + ugap - tb_border
                        end
                        g.x = g.x + ugap
                    end
                    c:geometry(g)
                end
            end
        end
    end
end
