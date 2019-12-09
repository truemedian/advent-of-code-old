
local Deque = require 'Deque'

local FILO = require 'class' ('FILO', Deque)

FILO.push = FILO.pushRight
FILO.peek = FILO.peekLeft
FILO.pop  = FILO.popLeft

return FILO