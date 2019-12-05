
local fs = require 'fs'

for i = 1, 25 do
    i = ('%02i'):format(i)

    if fs.existsSync(i) then
        print('Challenge ' .. i)
        require('./' .. i .. '/code.lua')
        print()
    end
end