--[[

@name Challenge 7
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local Intcode = require 'Intcode'

local util = require('util')
local input = util.get_input(module)

local reg = { }
local i = 0
for line in util.isplit(input, ',') do
    reg[i] = tonumber(line)
    i = i + 1
end

local big1, big2 = 0, 0

local A = Intcode(reg, 'A')
local B = Intcode(reg, 'B')
local C = Intcode(reg, 'C')
local D = Intcode(reg, 'D')
local E = Intcode(reg, 'E')

for data in util.ipermute(util.range(0, 4)) do
    local a, b, c, d, e = unpack(data)

    Intcode.resetAll(A, B, C, D, E)

    A:run(a, 0)
    B:run(b, A)
    C:run(c, B)
    D:run(d, C)
    E:run(e, D)

    big1 = math.max(big1, E.value)
end

for data in util.ipermute(util.range(5, 9)) do
    local a, b, c, d, e = unpack(data)

    Intcode.resetAll(A, B, C, D, E)

    A:run(a, 0)
    B:run(b, A)
    C:run(c, B)
    D:run(d, C)
    E:run(e, D)

    repeat
        A:run(E)
        B:run(A)
        C:run(B)
        D:run(C)
        E:run(D)
    until E.done

    big2 = math.max(big2, E.value)
end

print('Part 1:', big1)
print('Part 2:', big2)