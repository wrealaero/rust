local rust = shared.rust
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and rust then
		rust:CreateNotification('Rust', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/wrealaero/rust/'..readfile('rust/profiles/commit.txt')..'/'..select(1, path:gsub('rust/', '')), true)
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

rust.Place = 8768229691
if isfile('rust/games/'..rust.Place..'.lua') then
	loadstring(readfile('rust/games/'..rust.Place..'.lua'), 'skywars')()
else
	if not shared.RustDeveloper then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/wrealaero/rust/'..readfile('rust/profiles/commit.txt')..'/games/'..rust.Place..'.lua', true)
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('rust/games/'..rust.Place..'.lua'), 'skywars')()
		end
	end
end
