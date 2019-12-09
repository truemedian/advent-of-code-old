local operations = { }

local function add_operation(code, name, nargs, fn)
    operations[code] = {
        name = name,
        nargs = nargs,
        fn = fn
    }
end

local intcode_debug = false
local function bool(boolean) return boolean and 1 or 0 end
local function positional(reg, n, arg, mod) if mod[n] == 0 or mod[n] == nil then arg[n] = reg[arg[n]] end end
local function _debug(...) if intcode_debug then print(...) end end

add_operation(1, 'addition', 3, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    _debug(run._id, pos, 'adding', arg[1], arg[2], 'into', arg[3])
    reg[arg[3]] = arg[1] + arg[2]
end)

add_operation(2, 'multiply', 3, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    _debug(run._id, pos, 'multiplying', arg[1], arg[2], 'into', arg[3])
    reg[arg[3]] = arg[1] * arg[2]
end)

add_operation(3, 'input', 1, function(run, reg, pos, arg, mod)
    if run._inputs.length == 0 then
        run:_halt(false)
        _debug(run._id, pos, 'inputing', 'exhausted')
        return pos
    else
        local value = run._inputs:pop()
        _debug(run._id, pos, 'inputing', value, 'into', arg[1])
        reg[arg[1]] = value
    end
end)

add_operation(4, 'output', 1, function(run, reg, pos, arg, mod)
    _debug(run._id, pos, 'outputing', reg[arg[1]])
    run._outputs:push(reg[arg[1]])
end)

add_operation(5, 'jump if-not-zero', 2, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    if arg[1] ~= 0 then
        _debug(run._id, pos, 'jumping to', arg[2])
        return arg[2]
    else
        _debug(run._id, pos, 'skipping jump')
    end
end)

add_operation(6, 'jump if-zero', 2, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    if arg[1] == 0 then
        _debug(run._id, pos, 'jumping to', arg[2])
        return arg[2]
    else
        _debug(run._id, pos, 'skipping jump')
    end
end)

add_operation(7, 'less than', 3, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    _debug(run._id, pos, 'testing less than', arg[1], arg[2], 'into', arg[3])
    reg[arg[3]] = bool(arg[1] < arg[2])
end)

add_operation(8, 'equal', 3, function(run, reg, pos, arg, mod)
    positional(reg, 1, arg, mod)
    positional(reg, 2, arg, mod)

    _debug(run._id, pos, 'testing equal', arg[1], arg[2], 'into', arg[3])
    reg[arg[3]] = bool(arg[1] == arg[2])
end)

add_operation(99, 'exit', 0, function(run, reg, pos, arg, mod)
    _debug(run._id, pos, 'halting')
    run:_halt(true)
end)

return operations