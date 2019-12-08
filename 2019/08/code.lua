--[[

@name Challenge 8
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local width = 25
local height = 6

local least_zero = math.huge
local part1

local final = { }

local step = width * height
for layer = 1, #input, step do
    local str = input:sub(layer, layer + step - 1)

    local _, nzero = str:gsub('0', '')

    if nzero < least_zero then
        local _, none = str:gsub('1', '')
        local _, ntwo = str:gsub('2', '')

        least_zero = nzero
        part1 = none * ntwo
    end

    for part, i in util.isplit(str) do
        if not final[i] then
            if part == '1' or part == '0' then
                final[i] = part
            end
        end
    end
end

local lines = { }
for i = 1, #final, width do
    local str = table.concat(final, '', i, i + width - 1)
    table.insert(lines, (str:gsub('1', '#'):gsub('0', ' '):gsub('(.....)', '%1  ')))
end

local display = table.concat(lines, '\n')

print('Part 1:', part1)
print('Part 2:')
print(display)
