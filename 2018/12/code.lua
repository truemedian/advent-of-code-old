--[[

@name Challenge 12
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local initial, change_rules = input:match('initial state: ([^\n]+)(.+)')

local array = { }
local first = 0
local last = 0

for i = 1, #initial do
    array[i - 1] = initial:sub(i, i)
    last = i - 1
end

local rules = { }

local parse_line = '(.)(.)(.)(.)(.) => (.)'
for line in change_rules:gmatch('([^\n]+)') do
    local L, l, this, r, R, out = line:match(parse_line)

    rules[#rules + 1] = function(i)
        if (array[i - 2] or '.') == L and (array[i - 1] or '.') == l and (array[i] or '.') == this and (array[i + 1] or '.') == r and (array[i + 2] or '.') == R then
            return out
        end
    end
end

local gen = 0
local function run_generation()
    gen = gen + 1
    local this = { }
    for x = first - 2, last + 2 do
        local new = array[x]

        for _, rule in pairs(rules) do
            new = rule(x) or new
        end

        this[x] = new or '.'
    end


    first = first - 2
    while this[first] == '.' do
        this[first] = nil
        first = first + 1
    end

    last = last + 2
    while this[last] == '.' do
        this[last] = nil
        last = last - 1
    end
    
    array = this
end

for i = 1, 20 do
    run_generation()
end

local sum = 0
for i, x in pairs(array) do
    if x == '#' then
        sum = sum + i
    end
end

print('Part 1:', sum)

local check_diff = 0
local last_sum = 0
local last_diff = 0

repeat
    run_generation()

    local new_sum = 0
    for i, x in pairs(array) do
        if x == '#' then
            new_sum = new_sum + i
        end
    end

    local diff = new_sum - last_sum

    if diff == last_diff then
        check_diff = check_diff + 1
    else
        check_diff = 0
    end

    last_sum = new_sum
    last_diff = diff
until check_diff > 2000

print('Part 2:', (50000000000 - gen) * last_diff + last_sum)
