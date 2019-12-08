--[[

@name Challenge 7
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

local function run(inputs, copy)
    local last_output = ''

    local input_cursor = 1

    local pos = copy.pos or 0
    repeat
        local op, modes = copy[pos] % 100, string.format('%03i', math.floor(copy[pos] / 100))

        local arg1, arg2, arg3

        if op == 1 or op == 2 or op == 7 or op == 8 then
            if modes:sub(3, 3) == '1' then
                arg1 = copy[pos + 1]
            else
                arg1 = copy[copy[pos + 1]] or 0
            end

            if modes:sub(2, 2) == '1' then
                arg2 = copy[pos + 2]
            else
                arg2 = copy[copy[pos + 2]] or 0
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
            copy.halted = true
            break
        end

        if op == 1 then
            copy[arg3] = arg1 + arg2
            pos = pos + 4
        elseif op == 2 then
            copy[arg3] = arg1 * arg2
            pos = pos + 4
        elseif op == 3 then
            if input_cursor > #inputs then
                copy.halted = false
                break
            end

            copy[arg1] = inputs[input_cursor]
            input_cursor = input_cursor + 1

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

    copy.pos = pos

    return last_output, copy.halted
end

local big1, big2 = 0, 0

for a = 0, 4 do
    for b = 0, 4 do; if b ~= a then
        for c = 0, 4 do; if c ~= b and c ~= a then
            for d = 0, 4 do; if d ~= c and d ~= b and d ~= a then
                for e = 0, 4 do; if e~= d and e ~= c and e ~= b and e ~= a then
                    local out = 0

                    out = run({ a, out }, table.copy(reg))
                    out = run({ b, out }, table.copy(reg))
                    out = run({ c, out }, table.copy(reg))
                    out = run({ d, out }, table.copy(reg))
                    out = run({ e, out }, table.copy(reg))

                    big1 = math.max(big1, out)
                end end
            end end
        end end
    end end
end

for a = 5, 9 do
    for b = 5, 9 do; if b ~= a then
        for c = 5, 9 do; if c ~= b and c ~= a then
            for d = 5, 9 do; if d ~= c and d ~= b and d ~= a then
                for e = 5, 9 do; if e~= d and e ~= c and e ~= b and e ~= a then
                    local done

                    local amem, bmem, cmem, dmem, emem = table.copy(reg), table.copy(reg), table.copy(reg), table.copy(reg), table.copy(reg)
                    local out = 0

                    out = run({ a, out }, amem)
                    out = run({ b, out }, bmem)
                    out = run({ c, out }, cmem)
                    out = run({ d, out }, dmem)
                    out = run({ e, out }, emem)

                    repeat
                        out = run({ out }, amem)
                        out = run({ out }, bmem)
                        out = run({ out }, cmem)
                        out = run({ out }, dmem)
                        out, done = run({ out }, emem)
                    until done

                    big2 = math.max(big2, out)
                end end
            end end
        end end
    end end
end

print('Part 1:', big1)
print('Part 2:', big2)