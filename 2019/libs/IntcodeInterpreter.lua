
local Array = require 'Array'

local IntcodeInterpreter = require 'class' ('IntcodeInterpreter')
local util = require 'util'

function IntcodeInterpreter:__init(registry)
    self._original = registry

    self:reset()
end

function IntcodeInterpreter:reset()
	self._registry = table.copy(self._original)
	self._pointer = 0
	self._inputs = Array()
	self._outputs = { }
	self._halted = false	
end

function IntcodeInterpreter:push(...)
    for i = 1, select('#', ...) do
        self._inputs:pushBack(select(i, ...))
    end
end

function IntcodeInterpreter:check()
	return self._outputs[#self._outputs]
end

function IntcodeInterpreter:_halt(done, err)
	if err then
		error('intcode interpreter encountered an error at ptr=' .. self._pointer)
	else
		self._halted = done
	end
end

function IntcodeInterpreter:run()
	local reg, pos = self._registry, self._pointer
    repeat
        local op, modes = reg[pos] % 100, string.format('%03i', math.floor(reg[pos] / 100))

        local arg1, arg2, arg3

        if op == 1 or op == 2 or op == 7 or op == 8 then
            if modes:sub(3, 3) == '1' then
                arg1 = reg[pos + 1]
            else
                arg1 = reg[reg[pos + 1]] or 0
            end

            if modes:sub(2, 2) == '1' then
                arg2 = reg[pos + 2]
            else
                arg2 = reg[reg[pos + 2]] or 0
            end

            arg3 = reg[pos + 3]
        elseif op == 3 or op == 4 then
            arg1 = reg[pos + 1]
        elseif op == 5 or op == 6 then
            if modes:sub(3, 3) == '1' then
                arg1 = reg[pos + 1]
            else
                arg1 = reg[reg[pos + 1]]
            end

            if modes:sub(2, 2) == '1' then
                arg2 = reg[pos + 2]
            else
                arg2 = reg[reg[pos + 2]]
            end
        elseif op == 99 then
            self:_halt(true)
            break
        end

        if op == 1 then
            reg[arg3] = arg1 + arg2
            pos = pos + 4
        elseif op == 2 then
            reg[arg3] = arg1 * arg2
            pos = pos + 4
        elseif op == 3 then
            if self._inputs.length == 0 then
            	self:_halt(false)
                break
            end

            reg[arg1] = self._inputs:popFront()

            pos = pos + 2
        elseif op == 4 then
			table.insert(self._outputs, reg[arg1])
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
                reg[arg3] = 1
            else
                reg[arg3] = 0
            end
            pos = pos + 4
        elseif op == 8 then
            if arg1 == arg2 then
                reg[arg3] = 1
            else
                reg[arg3] = 0
            end
            pos = pos + 4
		else
			self._pointer = pos
			self:_halt(false, true)
            break
        end
	until op == 99

	self._pointer = pos
	return self._halted
end

return IntcodeInterpreter