
local util = { }

function util.iterkv(tbl)
    local k, v
    return function()
        k, v = next(tbl, k)
        return k, v
    end
end

function util.itervk(tbl)
    local k, v
    return function()
        k, v = next(tbl, k)
        return v, k
    end
end

function util.map(tbl, fn, ...)
    local new = { }
    for k, v in util.iterkv(tbl) do
        new[k] = fn(v, ...)
    end
    return new
end

function util.mapv(fn, ...)
    local tbl = { ... }
    local new = util.map(tbl, fn)
    return unpack(new)
end

function util.filter(tbl, fn)
    local new = { }
    for k, v in util.iterkv(tbl) do
        if fn(v) then
            new[k] = v
        end
    end
    return new
end

function util.infinite(tbl, default)
    return setmetatable(tbl, {
        __index = function(self, k)
            if type(default) == 'function' then
                self[k] = default()
            else
                self[k] = default
            end
            return self[k]
        end
    })
end

function util.list(...)
    return { ... }
end

function util.sum(tbl)
    local sum = 0
    for v in util.itervk(tbl) do
        sum = sum + v
    end
    return sum
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

function util.ilines(str, map)
    local tbl = util.lines(str)

    if map then
        tbl = util.map(tbl, map)
    end

    return util.itervk(tbl)
end

function util.isplit(str, delim)
    return util.itervk(util.split(str, delim))
end

function util.len(val)
    if type(val) == 'string' then
        return #val
    elseif type(val) == 'table' then
        local n = 0

        for _ in pairs(val) do
            n = n + 1
        end

        return n
    else
        return 0
    end
end

local function permutation(array, n, collect)
    if n == 0 then
        table.insert(collect, table.copy(array))
    else
        for i = 1, n do
            array[i], array[n] = array[n], array[i]
            permutation(array, n - 1, collect)
            array[i], array[n] = array[n], array[i]
        end
    end
end

function util.permute(array)
    local ret = { }

    permutation(array, #array, ret)

    return ret
end

function util.ipermute(array)
    return util.itervk(util.permute(array))
end

function util.range(start, stop, step)
    local ret = { }

    for i = start, stop, step or 1 do
        table.insert(ret, i)
    end

    return ret
end

local fs = require 'fs'
function util.get_input(mod)
    local input = fs.readFileSync(mod.dir .. '/input.txt')

    return input
end

-- inject utilities so they can be used as individual functions
for k, v in pairs(util) do
    _G[k] = v
end

function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function table.copy(tbl)
    local new = { }

    for k, v in pairs(tbl) do
        new[k] = v
    end

    return new
end

-- stack overflows are intentionally not handled here, if it becomes an issue I'll look into it.
function table.deepcopy(tbl)
    local new = { }

    for k, v in pairs(tbl) do
        new[k] = type(v) == 'table' and table.deepcopy(v) or v
    end

    return new
end

function table.shift(tbl, offset)
    if offset == 0 then return tbl end

    local new = { }
    for i, v in ipairs(tbl) do
        new[i + offset] = v
    end

    return new
end

return util
