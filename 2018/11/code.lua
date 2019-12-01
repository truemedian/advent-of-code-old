--[[

@name Challenge 11
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local serial = tonumber(util.get_input(module))

local array = { }

local num = tonumber
for x = 1, 300 do
    array[x] = { }
    for y = 1, 300 do
        local rack = x + 10
        local power = rack * y
        power = power + serial
        power = power * rack

        local spower = tostring(power)
        local hundred = #spower < 3 and '0' or spower:sub(-3, -3)
        local final = num(hundred) - 5

        array[x][y] = final
    end
end

local highest = { 0, 0, -1 }
for x = 1, 297 do
    for y = 1, 297 do
        local this = { }

        local power = 0
        for xx = 0, 2 do
            for yy = 0, 2 do
                power = power + array[x + xx][y + yy]
            end
        end

        if power > highest[3] then
            highest = { x, y, power }
        end
    end
end

print('Part 1:', highest[1] .. ',' .. highest[2])


local highest_size = { 0, 0, -1, 0}
for size = 0, 299 do
    for x = 1, 300 - size do
        for y = 1, 300 - size do
            local this = { }
            
            local power = 0
            for xx = 0, size do
                for yy = 0, size do
                    power = power + array[x + xx][y + yy]
                end
            end

            if power > highest[3] then
                highest = { x, y, power, size + 1 }
            end
        end
    end
end

print('Part 2:', highest[1] .. ',' .. highest[2] .. ',' .. highest[4])
