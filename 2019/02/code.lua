--[[

@name Challenge 2
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local reg = { }
for line in util.isplit(input, ',') do
    reg[#reg + 1] = tonumber(line)
end

local function run(n, v)
    local copy = { }

    for i = 1, #reg do
        copy[i] = reg[i]
    end

    copy[2] = n
    copy[3] = v

    local pos = 1
    repeat
        if copy[pos] == 1 then
            copy[copy[pos + 3] + 1] = copy[copy[pos + 1] + 1] + copy[copy[pos + 2] + 1]
            pos = pos + 4
        elseif copy[pos] == 2 then
            copy[copy[pos + 3] + 1] = copy[copy[pos + 1] + 1] * copy[copy[pos + 2] + 1]
            pos = pos + 4
        end
    until copy[pos] == 99

    return copy[1]
end

print('Part 1:', run(12, 2))
for n = 0, 99 do
    for v = 0, 99 do
        local value = run(n, v)

        if value == 19690720 then
            print('Part 2:', n * 100 + v)
            break
        end
    end
end