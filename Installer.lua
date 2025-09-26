local base = "https://raw.githubusercontent.com/AutumnV3/AutumnForRoblox/refs/heads/main/"

table.foreach({"AutumnV3", "AutumnV3/Games", "AutumnV3/Configs"}, function(i, v)
    if not isfolder(v) then
        makefolder(v)
    end
end)

table.foreach({"GuiLibrary.lua", "Main.lua"}, function(i, v)
    if not isfile('AutumnV3/ '.. v) then
        writefile("AutumnV3/" .. v, game:HttpGet(base .. v))
    end
end)

table.foreach({"BedwarZ.lua"}, function(i, v)
    if not isfile('AutumnV3/Games/' .. v) then
        writefile("AutumnV3/Games/" .. v, game:HttpGet(base .. "/Games" .. v))
    end
end)

task.wait(1)
