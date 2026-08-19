local Polymorphic = {}
local Utilities = require("core.utilities")

function Polymorphic.dynamic_code_generation_advanced(src)
    local lines = {}
    for line in src:gmatch("[^\n]*") do
        if not line:match("^%s*$") then
            table.insert(lines, line)
        end
    end
    local code_str = table.concat(lines, "\n")
    local enc = {}
    for i = 1, #code_str do
        enc[i] = string.byte(code_str, i)
    end
    local key = math.random(1, 255)
    local shuffled = {}
    for i = #enc, 1, -1 do
        shuffled[#shuffled+1] = enc[i] ~ key
    end
    local shuffled_str = table.concat(shuffled, ",")
    local gen = string.format([[
local _key = %d
local _data = {%s}
local function _rebuild()
    local s = {}
    for i = #_data, 1, -1 do
        s[#s+1] = string.char(_data[i] ~ _key)
    end
    return table.concat(s)
end
local _code = _rebuild()
local _fn, _err = loadstring(_code)
if _fn then
    _fn()
else
    error(_err)
end
]], key, shuffled_str)
    return gen
end

function Polymorphic.polymorphic_code_generation(src)
    local variants = {}
    for i = 1, 3 do
        local shuffled = {}
        local lines = {}
        for line in src:gmatch("[^\n]*") do
            if not line:match("^%s*$") then
                table.insert(lines, line)
            end
        end
        for i = #lines, 2, -1 do
            local j = math.random(1, i)
            lines[i], lines[j] = lines[j], lines[i]
        end
        local var_name = "poly_" .. Utilities.random_id()
        local code = table.concat(lines, "\n")
        table.insert(variants, string.format("local %s = function()\n%s\nend", var_name, code))
    end
    local selector = math.random(1, #variants)
    local poly_code = string.format([[
local _poly_variants = {
%s
}
local _selected = _poly_variants[%d]
_selected()
]], table.concat(variants, ",\n"), selector)
    return poly_code
end

return Polymorphic
