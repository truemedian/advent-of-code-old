--[[

@name Challenge 4
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

table.sort(input) -- order the lines

local current_guard
local last_sleep
local guards = { }

local num = tonumber

local parse_line = '%[%d%d%d%d%-%d%d%-%d%d %d%d:(%d%d)%] (%S+) (.+)' -- pattern to match variables in line
for _, line in pairs(input) do
    local min, first, msg = line:match(parse_line) -- parse out useful variables
    min = num(min)

    if first == 'wakes' then -- guard wakes up
        for i = last_sleep, min - 1 do -- add to all minutes
            guards[current_guard][i] = (guards[current_guard][i] or 0) + 1
        end

        last_sleep = nil
    elseif first == 'falls' then -- guard falls asleep
        last_sleep = min
    elseif first == 'Guard' then -- guard begins duty
        local id = msg:match('%d+') -- find id

        guards[id] = guards[id] or { } -- create table for minutes if not exist

        current_guard = id
        last_sleep = nil
    end
end

local highest_spent_asleep = { '-1', 0 }
for id, mins in pairs(guards) do
    local sum = 0
    for min, n in pairs(mins) do
        sum = sum + n -- sum up all minutes
    end

    if sum > highest_spent_asleep[2] then
        highest_spent_asleep = { id, sum } -- is this the highest sum?
    end
end

local best_minute_run = { -1, 0 }
for min, n in pairs(guards[highest_spent_asleep[1]]) do
    if n > best_minute_run[2] then
        best_minute_run = { min, n } -- which minute does he sleep the most
    end
end

print('Part 1:', highest_spent_asleep[1] * best_minute_run[1])

local most_asleep_on_min = { '-1', -1, 0 }
for id, mins in pairs(guards) do
    for min, n in pairs(mins) do
        if n > most_asleep_on_min[3] then -- do they sleep the most this minute?
            most_asleep_on_min = { id, min, n }
        end
    end
end

print('Part 2:', most_asleep_on_min[1] * most_asleep_on_min[2])
