--[[
usage: place script into $HOME/.mpv/scripts/ directory (%APPDATA%\mpv\scripts on windows)
  or run mpv --lua path/to/capture.lua
  or add "lua=/absolute/path/to/capture.lua" to ~/.config/mpv/mpv.conf (%APPDATA%\mpv\mpv.conf on windows)
keybindings:
  a - capture fragment: at first press script remembers start position, at second outputs command for encoding
  c - crop: first press remembers mouse cursor coords, second outputs crop filter parameters.
]]
capture = {}
local gp
if mp.get_property == nil then
    gp = mp.property_get
else
    gp = mp.get_property
end
function capture.handler()
    local c = capture
    if c.start then
        print(string.format("ffmpeg -ss %f -i '%s' -t %f",
            c.start, gp("path"), gp("time-pos")-c.start))
        print(string.format("mpv '%s' --start %s --length %s",
            gp("path"), c.start, gp("time-pos")-c.start))
        print(string.format("WebMaster -s %s -t %s '%s'",
            c.start, gp("time-pos")-c.start, gp("path")))
        c.start = nil
    else
        c.start = tonumber(gp("time-pos"))
    end
end
function capture.crop()
    local x, y = mp.get_mouse_pos()
    local resX, resY = mp.get_osd_resolution()
    -- print(x .. ":" .. y .. " " .. resX .. "x" .. resY )
    local c = capture
    if c.pos then
        local pos2 = mp.get_mouse_pos()
        local w, h = gp('width'), gp('height')
        print(string.format("crop=%d:%d:%d:%d",
            (x - c.pos[1]) * w / resX, (y - c.pos[2]) * h / resY,
            c.pos[1] * w / resX, c.pos[2] * h / resY))
        c.pos = nil
    else
        c.pos = {x, y}
    end
end
--mp.add_key_binding("a", "capture", capture.handler)
mp.set_key_bindings({
    {"c", capture.crop},
    {"a", capture.handler}
})
mp.enable_key_bindings()
