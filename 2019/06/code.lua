--[[

@name Challenge 6
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local planets = { }
local orbits  = { }

for line in util.ilines(input) do
    local a, b = line:match('^([^(]+)%)([^(]+)$')

    planets[b] = a
end

for planet, object in pairs(planets) do
    local current = object
    local dist = 1

    orbits[planet] = { n = 0 }
    while current do
        orbits[planet][current] = dist
        orbits[planet].n = orbits[planet].n + 1
        dist = dist + 1

        current = planets[current]
    end
end

local n_orbits   = 0

for _, v in pairs(orbits) do
    n_orbits = n_orbits + v.n
end

print('Part 1:', n_orbits)

local parent = 'YOU'

repeat
    parent = planets[parent]
until orbits.SAN[parent]

print('Part 2:', orbits.SAN[parent] + orbits.YOU[parent] - 2)
