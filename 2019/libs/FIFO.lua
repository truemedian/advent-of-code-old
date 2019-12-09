
local Deque = require 'Deque'

local FIFO = require 'class' ('FIFO', Deque)

FIFO.push = FIFO.pushRight
FIFO.peek = FIFO.peekRight
FIFO.pop  = FIFO.popRight

return FIFO