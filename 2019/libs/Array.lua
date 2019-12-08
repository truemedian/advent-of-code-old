
local Array, get = require 'class' ('Array')

function Array:__init(starting)
	self._arr = starting or { }
end

function Array:peekFront()
	return self._arr[1]
end

function Array:peekBack()
	return self._arr[#self._arr]
end

Array.peek = Array.peekBack

function Array:popFront()
	return table.remove(self._arr, 1)
end

function Array:popBack()
	return table.remove(self._arr)
end

Array.pop = Array.popBack

function Array:pushFront(value)
	return table.insert(self._arr, 1, value)
end

function Array:pushBack(value)
	return table.insert(self._arr, value)
end

Array.push = Array.pushBack

function get:length()
	return #self._arr
end

return Array