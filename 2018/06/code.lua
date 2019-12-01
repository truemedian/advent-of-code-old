--[[

@name Challenge 6
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local num = tonumber

local max_x, max_y = 0, 0
local min_x, min_y = math.huge, math.huge
local coords = { }

local parse_line = '(%d+), (%d+)'
for line in input:gmatch('([^\n]+)') do
    local x, y = line:match(parse_line)
    x, y = num(x), num(y)

    table.insert(coords, { x, y })

    max_x = math.max(max_x, x)
    max_y = math.max(max_y, y)

    min_x = math.min(min_x, x)
    min_y = math.min(min_y, y)
end

local useless = { }
local within_10000_range = 0

local all_positions = { }
for x = min_x, max_x do
    local row = { }
    for y = min_y, max_y do
        local closest = { 0, math.huge }
        local ties
        local ids_present = { }

        local total_coord_diff = 0

        for i, coord in pairs(coords) do
            ids_present[i] = true

            local dist_x = math.abs(coord[1] - x)
            local dist_y = math.abs(coord[2] - y)

            local manhattan = dist_x + dist_y
            total_coord_diff = total_coord_diff + manhattan

            if manhattan < closest[2] then
                closest = { i, manhattan }
            end
        end

        if total_coord_diff < 10000 then
            within_10000_range = within_10000_range + 1
        end

        for i, coord in pairs(coords) do
            local dist_x = math.abs(coord[1] - x)
            local dist_y = math.abs(coord[2] - y)

            local manhattan = dist_x + dist_y

            if manhattan == closest[2] and i ~= closest[1] then
                ties = i
                break
            end
        end

        row[y] = ties and nil or not ties and closest[1]

        if y == min_y or y == max_y then
            useless[closest[1]] = true
            if ties then
                useless[ties] = true
            end
        elseif x == min_x or x == max_x then
            useless[closest[1]] = true
            if ties then
                useless[ties] = true
            end
        end
    end

    all_positions[x] = row
end

local counts = { }
for x = min_x, max_x do
    for y = min_y, max_y do
        local pos = all_positions[x][y]

        if pos then
            if not useless[pos] then
                counts[pos] = (counts[pos] or 0) + 1
            end
        end
    end
end

local highest = { 0, -1 }
for id, n in pairs(counts) do
    if n > highest[2] then
        highest = { id, n }
    end
end

print('Part 1:', highest[2])
print('Part 2:', within_10000_range)
