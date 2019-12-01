--[[

@name Challenge 2
@event Advent of Code 2018
@author Nameless github.com/truemedian

]]

local util = require('util')
local input = util.get_input(module)

local alphabet = 'abcdefghijklmopqrstuvwxyz' -- alphabet to iterate over

-- start counting for totals of twos and threes to make checksum, also, start attempting to find same
local two_total, three_total = 0, 0
local same = ''

for line in input:gmatch('([^\n]+)') do
    local letters = { }
    for i = 1, #line do
        local char = line:sub(i, i)

        if letters[char] then -- add to counts of letters in line
            letters[char] = letters[char] + 1
        else
            letters[char] = 1
        end
    end

    local found_two, found_three -- find letters repeated two or three times
    for letter, n in pairs(letters) do
        if n == 2 and not found_two then
            found_two = true
            two_total = two_total + 1
        elseif n == 3 and not found_three then
            found_three = true
            three_total = three_total + 1
        end
    end

    if same == '' then -- shitcode to find same for part 2
        for more_line in input:gmatch('([^\n]+)') do
            if line ~= more_line then
                local letters = ''
                local mismatched = 0
                for i = 1, #line do -- check against all letters on line
                    if more_line:sub(i, i) ~= line:sub(i, i) then
                        mismatched = mismatched + 1

                        if mismatched > 1 then
                            letters = ''
                            break -- too many mismatches
                        end
                    else
                        letters = letters .. line:sub(i, i) -- add letters, this might be it!
                    end
                end

                if mismatched == 1 then
                    same = letters -- if one mismatch, then this is what we want
                end
            end
        end
    end
end

print('Part 1: ', two_total * three_total)
print('Part 2: ', same)
