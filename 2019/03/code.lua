--[[

@name Challenge 3
@event Advent of Code 2019
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

-- ugly definition of a infinite 2d array that is initialized with `{ id = 0, first_steps = -1 }'
local grid = setmetatable({ }, {
    __index = function(self, i)
        self[i] = setmetatable({ }, {
            __index = function(self, x)
                self[x] = { id = 0, first_steps = -1 }
                return self[x]
            end
        })
        return self[i]
    end
})

local intersections = { }

for line, i in util.ilines(input) do
    local instructions = { }

    -- split the string on `,` and creative the instructions array
    for inst in util.isplit(line, ',') do
        table.insert(instructions, { op = inst:sub(1, 1), dist = tonumber(inst:sub(2)) })
    end

    local pos = { y = 0, x = 0 }
    local steps = 0

    for _, inst in pairs(instructions) do
        local moves = inst.dist

        if inst.op == 'U' then
            repeat
                pos.y = pos.y + 1
                steps = steps + 1

                if grid[pos.y][pos.x].id ~= 0 and grid[pos.y][pos.x].id ~= i then
                    table.insert(intersections, { y = pos.y, x = pos.x, steps2 = steps, steps1 = grid[pos.y][pos.x].first_steps })
                end

                grid[pos.y][pos.x] = { id = i, first_steps = steps }

                moves = moves - 1
            until moves == 0
        elseif inst.op == 'D' then
            repeat
                pos.y = pos.y - 1
                steps = steps + 1

                if grid[pos.y][pos.x].id ~= 0 and grid[pos.y][pos.x].id ~= i then
                    table.insert(intersections, { y = pos.y, x = pos.x, steps2 = steps, steps1 = grid[pos.y][pos.x].first_steps })
                end

                grid[pos.y][pos.x] = { id = i, first_steps = steps }

                moves = moves - 1
            until moves == 0
        elseif inst.op == 'L' then
            repeat
                pos.x = pos.x - 1
                steps = steps + 1

                if grid[pos.y][pos.x].id ~= 0 and grid[pos.y][pos.x].id ~= i then
                    table.insert(intersections, { y = pos.y, x = pos.x, steps2 = steps, steps1 = grid[pos.y][pos.x].first_steps })
                end

                grid[pos.y][pos.x] = { id = i, first_steps = steps }

                moves = moves - 1
            until moves == 0
        elseif inst.op == 'R' then
            repeat
                pos.x = pos.x + 1
                steps = steps + 1

                if grid[pos.y][pos.x].id ~= 0 and grid[pos.y][pos.x].id ~= i then
                    table.insert(intersections, { y = pos.y, x = pos.x, steps2 = steps, steps1 = grid[pos.y][pos.x].first_steps })
                end

                grid[pos.y][pos.x] = { id = i, first_steps = steps }

                moves = moves - 1
            until moves == 0
        end
    end
end

local closest = math.huge
local sum = math.huge
for i, pos in pairs(intersections) do
    closest = math.min(math.abs(pos.y) + math.abs(pos.x), closest)
    sum = math.min(pos.steps1 + pos.steps2, sum)
end

print('Part 1:', closest)
print('Part 2:', sum)