local base = "https://raw.githubusercontent.com/AutumnV3/AutumnForRoblox/refs/heads/main/devbuild/"

local function getDownload(file)
    file = file:gsub('AutumnV3/', '')

    local suc, ret = pcall(function()
        return game:HttpGet(base .. file)
    end)

    return suc and ret or 'print("Failed to get ' .. file..'")'
end

local function downloadFile(file)
    file = 'AutumnV3/' .. file

    if not isfile(file) then
        writefile(file, getDownload(file))
    end

    repeat task.wait() until isfile(file)

    return readfile(file)
end

local function debugDownloadSuccess(file)
    local File = downloadFile(file)

    if isfile(file) then
        print('[AutumnV3]: Successfully downloaded', file)
    else
        print('[AutumnV3]: Failed to download', file)
    end

    return File
end

for i,v in {'AutumnV3', 'AutumnV3/Games', 'AutumnV3/Configs'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

debugDownloadSuccess('GuiLibrary.lua')

local Games = {'BedwarZ'}
for i,v in Games do
    debugDownloadSuccess('Games/'..v)
end

return loadstring(debugDownloadSuccess('Main.lua'))()
