local isfile = isfile or function(file)
        local suc, res = pcall(function()
                return readfile(file)
        end)
        return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
        writefile(file, '')
end

local function downloadFile(path, func)
        if not isfile(path) then
                local suc, res = pcall(function()
                        return game:HttpGet('https://raw.githubusercontent.com/0xEIite/rust/'..readfile('rust/profiles/commit.txt')..'/'..select(1, path:gsub('rust/', '')), true)
                end)
                if not suc or res == '404: Not Found' then
                        error(res)
                end
                if path:find('.lua') then
                        res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after rust updates.\n'..res
                end
                writefile(path, res)
        end
        return (func or readfile)(path)
end

local function wipeFolder(path)
        if not isfolder(path) then return end
        for _, file in listfiles(path) do
                if file:find('loader') then continue end
                if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after rust updates.')) == 1 then
                        delfile(file)
                end
        end
end


for _, folder in {'rust', 'rust/games', 'rust/profiles', 'rust/assets', 'rust/libraries', 'rust/guis'} do
        if not isfolder(folder) then
                makefolder(folder)
        end
end


if not shared.RustDeveloper then
        local _, subbed = pcall(function() 
                return game:HttpGet('https://github.com/0xEIite/rust') 
        end)
        local commit = subbed:find('currentOid')
        commit = commit and subbed:sub(commit + 13, commit + 52) or nil
        commit = commit and #commit == 40 and commit or 'main'
        local firstInstall = not isfile('rust/profiles/commit.txt')
        if commit == 'main' or (isfile('rust/profiles/commit.txt') and readfile('rust/profiles/commit.txt') or '') ~= commit then
                wipeFolder('rust')
                wipeFolder('rust/games')
                wipeFolder('rust/guis')
                wipeFolder('rust/libraries')
        end
        writefile('rust/profiles/commit.txt', commit)
        if firstInstall then
                local profiles = {
                        "default6872274481.txt",
                        "default6872265039.txt",
                        "6016588693.gui.txt"
                }
                for _, profile in next, profiles do
                        local path = 'rust/profiles/'..profile
                        downloadFile(path)
                end
        end
end

return loadstring(downloadFile('rust/main.lua'), 'main')()
