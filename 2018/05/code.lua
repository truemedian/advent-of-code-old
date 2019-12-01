--[[

@name Challenge 5
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local alphabet = 'abcdefghijklmnopqrstuvwxyz' -- alphabest to iterate over

local repls = { }

for i = 1, #alphabet do
    local letter = alphabet:sub(i, i)

    -- populate repls with all the patterns we need to replace
    table.insert(repls, letter:lower() .. letter:upper())
    table.insert(repls, letter:upper() .. letter:lower())
end

function replace_all(str) -- replace all patterns in a string until you can no longer
    local tn, n = 0
    for _, repl in pairs(repls) do
        str, n = str:gsub(repl, '')
        tn = tn + n -- add to total n, and shrink the string
    end

    if tn ~= 0 then -- if you made a change, try more, else, return
        return replace_all(str)
    else
        return str
    end
end

print('Part 1:', #replace_all(input))

local best = { }
for i = 1, #alphabet do -- try removing every letter and see which works best
    local char = alphabet:sub(i, i)
    
    local new = input:gsub(char:lower(), ''):gsub(char:upper(), '') -- remove both polarities

    best[char] = #replace_all(new)
end

local best_to_remove = math.huge
for char, n in pairs(best) do
    if n < best_to_remove then
        best_to_remove = n -- is this the best to remove?
    end
end

print('Part 2:', best_to_remove)
