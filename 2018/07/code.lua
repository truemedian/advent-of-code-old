--[[

@name Challenge 7
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

local prerequisites = { }
local prerequisites2 = { }

for i = 1, #alphabet do
    prerequisites[alphabet:sub(i, i)] = { }
    prerequisites2[alphabet:sub(i, i)] = { }
end

local parse_line = 'Step ([A-Z]) must be finished before step ([A-Z]) can begin.'
for line in input:gmatch('([^\n]+)') do
    local preq, step = line:match(parse_line)

    table.insert(prerequisites[step], preq)
    table.insert(prerequisites2[step], preq)
end

local function count(tbl)
    local n = 0

    for _ in pairs(tbl) do
        n = n + 1
    end

    return n
end

local complete = { }
local order = { }
while #order ~= #alphabet do
    for i = 1, #alphabet do
        local step = alphabet:sub(i, i)

        if not complete[step] then
            local preq = prerequisites[step]

            if count(preq) == 0 then
                for _, this in pairs(prerequisites) do
                    for i, pre in pairs(this) do
                        if pre == step then
                            this[i] = nil
                        end
                    end
                end
                
                complete[step] = true
                order[#order + 1] = step
                break
            end
        end
    end
end

print('Part 1:', table.concat(order))

local complete = { }
local working_on = { }

local order = { }

local NUM_ELVES = 5
local SET_TIME = 60

local working = { }
local function step()
    for w = 1, NUM_ELVES do
        if working[w] then
            working[w][1] = working[w][1] - 1

            local set = working[w]
            if set[1] == 0 then
                local step = set[2]
                complete[step] = true
                order[#order + 1] = step
                
                for _, this in pairs(prerequisites2) do
                    for i, pre in pairs(this) do
                        if pre == step then
                            this[i] = nil
                        end
                    end
                end
                
                working_on[step] = nil
                working[w] = nil
            end
        end
    end

    for w = 1, NUM_ELVES do
        local do_work = true
        if working[w] then
            if working[w][1] ~= 0 then
                do_work = false
            end
        end

        if do_work then
            for i = 1, #alphabet do
                local step = alphabet:sub(i, i)

                if not complete[step] and not working_on[step] then
                    local preq = prerequisites2[step]

                    if count(preq) == 0 then
                        working[w] = { SET_TIME + i, step }
                        working_on[step] = true

                        break
                    end
                end
            end
        end
    end
end

for i = 0, 24 * 60 * 60 do
    step()

    if #order == #alphabet and count(working) == 0 then
        print('Part 2:', i)
        break
    end
end
