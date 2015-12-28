    -- conky.lua
    do

    -- get a color on a gradient between the given color an red
    function gradient (u,color)
            local c=color
            local r,g,b = tonumber('0x' .. c:sub(1,2)), tonumber('0x' .. c:sub(3,4)), tonumber('0x' .. c:sub(5,6))
            local r2,g2,b2 = 0xAD, 0x00, 0x00
            local r3=interpolate(r,r2,u,100)
            local g3=interpolate(g,g2,u,100)
            local b3=interpolate(b,b2,u,100)
            local color = (r3 * 0x10000) + (g3 * 0x100) + b3
            return string.format("${color #%06x}", color%0xffffff)
    end

        -- get a color on a gradient between the given color an greenish
    function gradient_green (u,color)
            local c=color
            local r,g,b = tonumber('0x' .. c:sub(1,2)), tonumber('0x' .. c:sub(3,4)), tonumber('0x' .. c:sub(5,6))
            local r2,g2,b2 = 0x00, 0x66, 0x11
            local r3=interpolate_green(r,r2,u,100)
            local g3=interpolate_green(g,g2,u,100)
            local b3=interpolate_green(b,b2,u,100)
            local color = (r3 * 0x10000) + (g3 * 0x100) + b3
            if u > 95 then color = 9900099 end
            return string.format("${color #%06x}", color%0xffffff)
    end

            -- get a color on a gradient between the given color an redish
    function gradient_redish (u,color)
            local c=color
            local r,g,b = tonumber('0x' .. c:sub(1,2)), tonumber('0x' .. c:sub(3,4)), tonumber('0x' .. c:sub(5,6))
            local r2,g2,b2 = 0xAD, 0x00, 0x11
            local r3=interpolate_red(r,r2,u,100)
            local g3=interpolate_red(g,g2,u,100)
            local b3=interpolate_red(b,b2,u,100)
            local color = (r3 * 0x10000) + (g3 * 0x100) + b3
            return string.format("${color #%06x}", color%0xffffff)
    end

    -- perform linear interpolation of two colors
    function interpolate(color1,color2,value,valuemax)
            local endcolor
            if color1 < color2 then
                    endcolor=((color2 - color1) * (value/valuemax)) + color1
            else
                    endcolor=((color1 - color2) * (1 - (value/valuemax))) + color2
            end
            return math.ceil(endcolor)
    end

        -- perform linear interpolation of two colors
    function interpolate_green(color1,color2,value,valuemax)
            local endcolor
            if value < 50 then value = 50 end
            if color1 < color2 then
                    endcolor=((color2 - color1) * (value/valuemax)) + color1
            else
                    endcolor=((color1 - color2) * (1 - (value/valuemax))) + color2
            end
            return math.ceil(endcolor)
    end

            -- perform linear interpolation of two colors
    function interpolate_red(color1,color2,value,valuemax)
            local endcolor
            if value > 40 then value = 40 end
            if color1 < color2 then
                    endcolor=((color2 - color1) * (value/valuemax)) + color1
            else
                    endcolor=((color1 - color2) * (1 - (value/valuemax))) + color2
            end
            return math.ceil(endcolor)
    end

    --  display mounted filesystems
    function conky_fs(f,bar_color,pct_color)
                    local t = ""
                    t = string.format("${if_mounted %s}${color0}%s${goto 115}${color1}${fs_size %s}${goto 160}%s${color1}${alignr 5}${fs_free %s}${endif}", f, f, f, fsbar(f, bar_color, pct_color), f)
                    return t
    end

    -- colors fs bar according percentage of usage
    function fsbar (fs,bgcolor,fg)
            local percent=conky_parse('${fs_used_perc ' .. fs .. '}')
            local u=tonumber(percent)
            if u < 10 then percent =  ' ' .. percent end
            return string.format("%s${fs_bar %s}", gradient_green(u,bgcolor), fs)
    end

    -- cpufreq
    function conky_cpufreq_max()
            local freq = tonumber(conky_parse('${head /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1}'));
            return string.format('%0.2f', freq / 1000);
    end

    -- colors cpu bar according percentage of usage
    function conky_cpubar (cpu,bgcolor,fgcolor)
            local percent=conky_parse('${cpu cpu' .. cpu .. '}')
            local u=tonumber(percent)
            local fg=fgcolor
            if u < 10 then percent =  ' ' .. percent end
            local freq=conky_parse('${freq ' .. cpu .. '}')
            local v=tonumber(freq)
            if v < 1000 then freq =  '  ' .. freq end
            return string.format("%s${cpubar cpu%s 10,110}${offset -56}${color %s}%s", gradient(u,bgcolor), cpu, fg, freq)
    end

    -- monitor apcupsd
    function conky_apcupsd(s,bgcolor,fgcolor)
            t = ""
            local sp = s
            local fg = fgcolor
            local bg = bgcolor
            u = conky_apcbar(bg,fg)
            if ( u ~= "" ) then t = string.format("${if_match \"${apcupsd_model}\" != \"N/A\"}${voffset %s}${color1}APC: ${color6}${apcupsd_model}${color2}${hr}\n${color6}status${goto 60}load${alignr 20}charge${alignr 15}timeleft${alignr 5}linev\n%s${endif}",s,u) end
            return t
    end

    -- colors apcupsd bar according percentage of usage
    function conky_apcbar (bgcolor,fgcolor)
            local t = ""
            local percent = conky_parse('${apcupsd_load}')
            if ( percent ~= "N/A" ) then
                    local charge  = conky_parse('${apcupsd_charge}')
                    local u = math.floor(tonumber(percent))
                    local l = math.floor(tonumber(charge))
                    percent = u
                    charge = l
                    local fg = fgcolor
                    local bg = bgcolor
                    if u < 10 then percent =  ' ' .. percent end
                    t = string.format("${color8}${apcupsd_status}${offset 10}%s${apcupsd_loadbar}${offset -55}${color %s}%s%%${color8}${alignr 30}%s%%${alignr 20}${apcupsd_timeleft}m${alignr 5}${apcupsd_linev}V", gradient(u,bg), fg, percent, charge)
            end
            return t
    end

    -- display the n top processes with color if under load
    function conky_tops (top_type, n)
            local all_proc = ""
            local top = "top"
            if ( top_type == "mem" ) then top = "top_mem" end
            for i=1,tonumber(n) do
                    name = conky_parse('${' .. top .. ' name ' .. i ..'}')
                    load = tonumber(conky_parse('${' .. top .. ' ' .. top_type .. ' ' .. i ..'}'))
                    local single_proc = string.format("%s%s${goto 155}${%s cpu %s}${alignr 5}${%s mem_res %s}", top_color(load, 0xd3, 25, 5), name, top, i, top, i, top,i)
                    if ( all_proc == "" ) then all_proc = single_proc else all_proc = all_proc .. "\n" .. single_proc end
            end
            return all_proc
    end

    -- this function changes Conky's top color based on a threshold
    function top_color(value, default_color, upper_thresh, lower_thresh)
            local r, g, b = default_color, default_color, default_color
            local color = 0
            local thresh_diff = upper_thresh - lower_thresh
            if (value == nil ) then value = 0 end
            if (value - lower_thresh) > 0 then
                    if value > upper_thresh then value = upper_thresh end
                    -- add some redness, depending on the 'strength'
                    r = math.ceil(default_color + ((value - lower_thresh) / thresh_diff) * (0xff - default_color))
                    b = math.floor(default_color - ((value - lower_thresh) / thresh_diff) * default_color)
                    g = b
            end
            color = (r * 0x10000) + (g * 0x100) + b -- no bit shifting operator in Lua afaik
            return string.format("${color #%06x}", color%0xffffff)

    end

    -- parses the output from top and calls the color function
    function conky_hourstime (d)
            fag = string.sub(d, -20)
            return fag
    end

    -- list/table if the file does not exist
    function conky_checkupdates(file)
      local f = io.open(file, "rb")
      local numb_updates = tonumber(f:read())
      if f then f:close() end
      local col = "white"
      if numb_updates > 10 then col = "yellow1" end
      if numb_updates > 20 then col = "DarkOrange1" end
      if numb_updates > 50 then col = "red" end
      return string.format("${color %s}%s", col, numb_updates)
    end

    end

