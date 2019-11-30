local fs = require 'fs'

local function get_input(mod)
    local num = mod.dir:match('Challenge (%d+)')

    local input = fs.readFileSync(mod.dir .. '/input.txt')

    return input
end

local function lines(str)
    local lines = { }

    for line in str:gmatch('([^\n]+)') do
        table.insert(lines, line)
    end

    return lines
end

return {
    get_input = get_input,
    lines = lines
}