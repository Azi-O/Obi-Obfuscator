local Wrappers = {}

function Wrappers.metatable_obfuscation(src)
    local wrapper = [[
local _mt = setmetatable({}, {
    __index = function(t, k)
        return rawget(t, k)
    end,
    __newindex = function(t, k, v)
        rawset(t, k, v)
    end,
    __call = function(t, ...)
        return t._func(...)
    end,
    __concat = function(a, b)
        return tostring(a) .. tostring(b)
    end
})
local _proxy = _mt
_proxy._func = function()
]] .. src .. [[
end
_proxy()
]]
    return wrapper
end

function Wrappers.anti_decompilation_techniques(src)
    local anti = string.format([[
local _t = {}
local _meta = {}
for i = 1, 100 do
    _t[i] = i
    _meta[i] = i * 2
end
setmetatable(_t, { __index = function(_, k) return _meta[k] end })
local function _wrap(f)
    return function(...)
        local args = {...}
        return f(unpack(args))
    end
end
local _orig = %s
local _wrapped = _wrap(_orig)
_wrapped()
]], src)
    return anti
end

function Wrappers.garbage_collection_manipulation(src)
    local gc_code = [[
collectgarbage("stop")
local function _gc_manip()
    local large_table = {}
    for i = 1, 10000 do
        large_table[i] = {i, i*2, i*3}
    end
    large_table = nil
    collectgarbage("collect")
    collectgarbage("collect")
    local function _gen_garbage()
        local t = {}
        for i = 1, 1000 do
            t[i] = string.rep("x", 1000)
        end
        return t
    end
    for i = 1, 10 do
        _gen_garbage()
    end
    collectgarbage("collect")
end
_gc_manip()
]] .. src
    return gc_code
end

function Wrappers.wrap_in_self_executing(src)
    return "(function() " .. src .. " end)()"
end

return Wrappers
