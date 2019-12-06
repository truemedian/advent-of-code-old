--[[

@name Challenge 5
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local reg = { }
local i = 0
for line in util.isplit(input, ',') do
    reg[i] = tonumber(line)
    i = i + 1
end

local function run(id)
    local copy = { }

    for i = 0, #reg do
        copy[i] = reg[i]
    end

    local last_output = ''

    local pos = 0
    repeat
        local op, modes = copy[pos] % 100, string.format('%03i', math.floor(copy[pos] / 100))

        local arg1, arg2, arg3

        if op == 1 or op == 2 or op == 7 or op == 8 then
            if modes:sub(3, 3) == '1' then
                arg1 = copy[pos + 1]
            else
                arg1 = copy[copy[pos + 1]]
            end

            if modes:sub(2, 2) == '1' then
                arg2 = copy[pos + 2]
            else
                arg2 = copy[copy[pos + 2]]
            end

            arg3 = copy[pos + 3]
        elseif op == 3 or op == 4 then
            arg1 = copy[pos + 1]
        elseif op == 5 or op == 6 then
            if modes:sub(3, 3) == '1' then
                arg1 = copy[pos + 1]
            else
                arg1 = copy[copy[pos + 1]]
            end

            if modes:sub(2, 2) == '1' then
                arg2 = copy[pos + 2]
            else
                arg2 = copy[copy[pos + 2]]
            end
        elseif op == 99 then
            break
        end

        if op == 1 then
            copy[arg3] = arg1 + arg2
            pos = pos + 4
        elseif op == 2 then
            copy[arg3] = arg1 * arg2
            pos = pos + 4
        elseif op == 3 then
            copy[arg1] = id
            pos = pos + 2
        elseif op == 4 then
            last_output = copy[arg1]
            pos = pos + 2
        elseif op == 5 then
            if arg1 ~= 0 then
                pos = arg2
            else
                pos = pos + 3
            end
        elseif op == 6 then
            if arg1 == 0 then
                pos = arg2
            else
                pos = pos + 3
            end
        elseif op == 7 then
            if arg1 < arg2 then
                copy[arg3] = 1
            else
                copy[arg3] = 0
            end
            pos = pos + 4
        elseif op == 8 then
            if arg1 == arg2 then
                copy[arg3] = 1
            else
                copy[arg3] = 0
            end
            pos = pos + 4
        elseif op ~= 99 then
            print('broken')
            break
        end
    until op == 99

    return last_output
end

print('Part 1:', run(1))
print('Part 2:', run(5))