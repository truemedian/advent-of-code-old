--[[

@name Challenge 1
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local current_freq = 0
local prev = { [0] = true } -- record seen freq

local repeated_twice

function parse()
    local parse_line = '([+-])(%d+)' -- pattern to parse input lines
    for line in input:gmatch('([^\n]+)') do
        local sign, num = line:match(parse_line) -- find variables from line

        if sign == '+' then -- add or sub from freq
            current_freq = current_freq + num
        elseif sign == '-' then
            current_freq = current_freq - num
        end

        if prev[current_freq] and not repeated_twice then
            repeated_twice = current_freq
            break -- determine first repetition
        else
            prev[current_freq] = true -- mark freq as seen
        end
    end
end

parse() -- parse for first answer

print('Part 1:', current_freq)

repeat -- use repeat loop, this may take a while
    parse()
until repeated_twice

print('Part 2:', repeated_twice)
