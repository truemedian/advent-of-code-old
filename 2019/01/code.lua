--[[

@name Challenge 1
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local calculate_fuel
function calculate_fuel(num, recalc)
    local fuel = math.floor(num / 3) - 2

    if not recalc then
        return fuel
    elseif fuel < 0 then
        return 0
    end

    local depend = calculate_fuel(fuel, true)

    return fuel + depend
end

local sum1 = 0
local sum2 = 0
for line in util.ilines(input, tonumber) do
    sum1 = sum1 + calculate_fuel(line, false)
    sum2 = sum2 + calculate_fuel(line, true)
end

print('Part 1:', sum1)
print('Part 2:', sum2)