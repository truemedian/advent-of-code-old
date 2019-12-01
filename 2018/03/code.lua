--[[

@name Challenge 3
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local fabric = { }
local ARRAY_SIZE = 1000 -- size provided by challenge

-- make 2d array for positioning
for x = 1, ARRAY_SIZE do
    fabric[x] = { }
    for y = 1, ARRAY_SIZE do
        fabric[x][y] = { }
    end
end

local num = tonumber

local parse_line = '#(%d+) @ (%d+),(%d+): (%d+)x(%d+)' -- pattern to parse input lines
for line in input:gmatch('([^\n]+)') do
    local id, posx, posy, sizex, sizey = line:match(parse_line) -- find variables from line
    posx, posy, sizex, sizey = num(posx) + 1, num(posy) + 1, num(sizex) - 1, num(sizey) - 1 -- convert to number and into correct form for use

    -- add id to position in array
    for x = posx, posx + sizex do
        for y = posy, posy + sizey do
            table.insert(fabric[x][y], id)
        end
    end
end

local n = 0
local no_overlaps = { }
local overlaps    = { }

for x = 1, ARRAY_SIZE do
    for y = 1, ARRAY_SIZE do
        -- check for overlaps
        if #fabric[x][y] > 1 then
            n = n + 1

            for _, id in pairs(fabric[x][y]) do
                overlaps[id] = true
            end
        elseif #fabric[x][y] == 1 then -- check for only in tile
            no_overlaps[fabric[x][y][1]] = true
        end
    end
end

-- output
print('Part 1:', n)

for id in pairs(no_overlaps) do
    if not overlaps[id] then -- find claims with no overlap
        print('Part 2:', id)
    end
end
