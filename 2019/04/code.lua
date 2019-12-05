--[[

@name Challenge 4
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local range = util.split(input, '-')
local min, max = range[1], range[2]

local sum1 = 0
local sum2 = 0
for i = min, max do
    i = tostring(i)

    local has_double = false
    local double = { }
    local triple = { }
    local decrease = false

    local back = ''
    local last = ''

    for x = 1, #i do
        local c = i:sub(x, x)

        if c == last then
            has_double = true
            double[c] = true
        end

        if c == back then
            triple[c] = true
        end

        if tonumber(c) < (tonumber(last) or 0) then
            decrease = true
        end

        back = last
        last = c
    end

    local has_single_double = false
    for x in pairs(double) do
        if not triple[x] then
            has_single_double = true
        end
    end

    if has_double and not decrease then
        sum1 = sum1 + 1
    end

    if has_single_double and not decrease then
        sum2 = sum2 + 1
    end
end

print('Part 1:', sum1)
print('Part 2:', sum2)