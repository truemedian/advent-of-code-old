--[[

@name Challenge 5
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local Intcode = require 'IntcodeInterpreter'

local util = require('util')
local input = util.get_input(module)

local reg = { }
local i = 0
for line in util.isplit(input, ',') do
    reg[i] = tonumber(line)
    i = i + 1
end

local big1, big2 = 0, 0

local A = Intcode(reg)
local B = Intcode(reg)
local C = Intcode(reg)
local D = Intcode(reg)
local E = Intcode(reg)

for data in util.ipermute(util.range(0, 4)) do
    local setting_a, setting_b, setting_c, setting_d, setting_e = unpack(data)

    A:reset()
    B:reset()
    C:reset()
    D:reset()
    E:reset()

    A:push(setting_a, 0)
    A:run(true)

    B:push(setting_b, A:check())
    B:run(true)

    C:push(setting_c, B:check())
    C:run(true)

    D:push(setting_d, C:check())
    D:run(true)

    E:push(setting_e, D:check())
    E:run(true)

    big1 = math.max(big1, E:check())
end

for data in util.ipermute(util.range(5, 9)) do
    local setting_a, setting_b, setting_c, setting_d, setting_e = unpack(data)

    A:reset()
    B:reset()
    C:reset()
    D:reset()
    E:reset()

    A:push(setting_a, 0)
    A:run()

    B:push(setting_b, A:check())
    B:run()

    C:push(setting_c, B:check())
    C:run()

    D:push(setting_d, C:check())
    D:run()

    E:push(setting_e, D:check())
    E:run()

    repeat
        A:push(E:check())
        A:run()

        B:push(A:check())
        B:run()

        C:push(B:check())
        C:run()

        D:push(C:check())
        D:run()

        E:push(D:check())
        local done = E:run()
    until done

    big2 = math.max(big2, E:check())
end

print('Part 1:', big1)
print('Part 2:', big2)