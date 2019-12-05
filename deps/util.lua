local fs = require 'fs'

local util = { }

function util.get_input(mod)
    local input = fs.readFileSync(mod.dir .. '/input.txt')

    return input
end

function util.split(str, delim)
    local ret = { }

	if not str then
		return ret
    end

	if not delim or delim == '' then
		for c in string.gmatch(str, '.') do
			table.insert(ret, c)
        end

		return ret
    end

    local n = 1
	while true do
		local i, j = string.find(str, delim, n)
		if not i then break end
		table.insert(ret, string.sub(str, n, i - 1))
		n = j + 1
    end

    table.insert(ret, string.sub(str, n))

	return ret
end

function util.lines(str)
    return util.split(str, '\n')
end

function util.iterv(array)
    local k, v
    return function()
        k, v = next(array, k)
        return v, k
    end
end

function util.map(tbl, fn)
    for k, v in pairs(tbl) do
        tbl[k] = fn(v)
    end
end

function util.ilines(str, map)
    local tbl = util.lines(str)

    if map then
        util.map(tbl, map)
    end

    return util.iterv(tbl)
end

function util.isplit(str, delim)
    return util.iterv(util.split(str, delim))
end

return util