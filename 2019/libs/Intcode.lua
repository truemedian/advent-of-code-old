
local FILO = require 'FILO'
local FIFO = require 'FIFO'

local isInstanceOf = require 'class' .isInstance
local Intcode, get = require 'class' ('Intcode')
local util = require 'util'

local ids = 1
function Intcode:__init(registry, id)
    assert(type(registry) == 'table', 'invalid registry')
    assert(#registry > 0, 'registry is too short')
    assert(registry[0], 'registry is shifted')

    self._original = registry
    self._id = id or ids
    ids = ids + 1

    self:reset(true)
end

function Intcode:reset()
	self._registry = table.copy(self._original)
	self._pointer = 0
	self._inputs = FILO()
	self._outputs = FIFO()
    self._halted = false
    self._done = false
end

function Intcode:push(...)
    for i = 1, select('#', ...) do
        local obj = select(i, ...)

        if isInstanceOf(obj, Intcode) then
            obj = obj:peek()
        elseif type(obj) ~= 'number' then
            error('input provided was not an integer')
        end

        self._inputs:push(obj)
    end
end

function Intcode:peek()
	return self._outputs:peek()
end

function Intcode:_halt(done)
    self._done = done
    self._halted = true
end

function Intcode:_read_op()
    local opcode = self._registry[self._pointer]

    local operation = opcode % 100
    local int = math.floor(opcode / 100)
    local modes = { }

    local i = 1
    repeat
        modes[i] = int % 10
        int = math.floor(int / 10)

        i = i + 1
    until int <= 0

    return operation, modes
end

local operations = require 'Intcode.ops'

function Intcode:step()
    if self._done then return true end
    local op, modes = self:_read_op()

    local info = operations[op]
    if info then
        local args = { }

        for i = 1, info.nargs do
            args[i] = self._registry[self._pointer + i]
        end

        local new_ptr = info.fn(self, self._registry, self._pointer, args, modes)
        self._pointer = new_ptr or (self._pointer + info.nargs + 1)
    else
        local message = 'unhandled operation %s at position %s'

        print(message:format(op, self._pointer))
        print(table.concat(self._registry, ' ', 0))
        process:exit(0)
    end

    return self._halted
end

function Intcode:run(...)
    if self._done then return true end

    if select('#', ...) > 0 then
        self:push(...)
    end

    self._halted = false
    repeat
        self:step()
    until self._halted

	return self._done
end

function Intcode.resetAll(...)
    for i = 1, select('#', ...) do
        select(i, ...):reset()
    end
end

function get.halted(self)
    return self._halted
end

function get.done(self)
    return self._done
end

function get.position(self)
    return self._pointer
end

function get.value(self)
    return self:peek()
end

return Intcode