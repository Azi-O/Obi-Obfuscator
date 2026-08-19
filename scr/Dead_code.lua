local DeadCode = {}
local Utilities = require("core.utilities")

function DeadCode.inject_dead_code_advanced(src)
    local dead_templates = {
        "if (function() local _=0; for _=1,10 do _=_+1 end; return _==10 end)() then local " .. Utilities.random_id() .. "=" .. math.random(1,9999) .. "; else local " .. Utilities.random_id() .. "=" .. math.random(1,9999) .. "; end",
        "local function " .. Utilities.random_id() .. "(x) return (function(y) return y+" .. math.random(1,999) .. " end)(x) end; " .. Utilities.random_id() .. "(" .. math.random(1,999) .. ")",
        "local _mt={__index=function(t,k) return k end}; local _t=setmetatable({},_mt); local _=" .. Utilities.random_id() .. "=_t['" .. Utilities.random_id() .. "'];",
        "do local _a=0; for _b=1,100 do _a=_a+1; if _a>50 then break end; end; end",
        "local function " .. Utilities.random_id() .. "(n) if n<=0 then return 0 else return " .. Utilities.random_id() .. "(n-1)+" .. math.random(1,9) .. " end end; " .. Utilities.random_id() .. "(" .. math.random(1,5) .. ")",
        "local _=" .. Utilities.random_id() .. "=(" .. math.random(1,100) .. "^" .. math.random(1,3) .. "+" .. math.random(1,100) .. "//" .. math.random(1,10) .. ")&" .. math.random(1,255),
        "loadstring('local _=" .. Utilities.random_id() .. "=" .. math.random(1,999) .. "')()",
        "local " .. Utilities.random_id() .. "=setmetatable({},{__index=function(_,k)return " .. Utilities.random_id() .. "[k] end})",
        "do local " .. Utilities.random_id() .. "=0; repeat " .. Utilities.random_id() .. "=" .. Utilities.random_id() .. "+1; until " .. Utilities.random_id() .. ">" .. math.random(10,50) .. " end",
        "local function " .. Utilities.random_id() .. "(...) local args={...}; return #args end; " .. Utilities.random_id() .. "(1,2,3,4)",
        "local function " .. Utilities.random_id() .. "() local t={}; for i=1," .. math.random(5,15) .. " do t[i]=i; end; return #t end; " .. Utilities.random_id() .. "()",
        "local _x,_y=" .. math.random(1,100) .. "," .. math.random(1,100) .. "; local _z=_x+_y; if _z>0 then local _a=" .. Utilities.random_id() .. "=" .. math.random(1,999) .. " end",
        "local _mt=setmetatable({},{__index=function(t,k) return k..'_' end}); local _t=_mt['" .. Utilities.random_id() .. "'];",
    }
    local lines = {}
    for line in src:gmatch("[^\n]*") do
        if not line:match("^%s*$") and not line:match("^%s*%-%-") then
            if math.random() < 0.85 then
                local template = dead_templates[math.random(#dead_templates)]
                line = line .. " " .. template .. " "
            end
            if math.random() < 0.65 then
                line = "local " .. Utilities.random_id() .. "=" .. math.random(1,999) .. "; " .. line
            end
            if math.random() < 0.55 then
                line = "(function() local " .. Utilities.random_id() .. "=" .. math.random(1,999) .. "; return " .. Utilities.random_id() .. " end)(); " .. line
            end
            if math.random() < 0.45 then
                line = line .. " .. (function() return '" .. Utilities.random_id() .. "' end)()"
            end
            if math.random() < 0.35 then
                line = "AT_CHECK(); " .. line
            end
            if math.random() < 0.25 then
                line = "local " .. Utilities.random_id() .. "=function(x) return x+" .. math.random(1,999) .. " end; " .. line
            end
            if math.random() < 0.2 then
                line = "do local _a=" .. math.random(1,999) .. "; local _b=" .. math.random(1,999) .. "; local _c=_a+_b; end; " .. line
            end
        end
        lines[#lines+1] = line
    end
    return table.concat(lines, "\n")
end

function DeadCode.add_dummy_functions_advanced(src)
    local dummy_funcs = {}
    for i = 1, math.random(20, 40) do
        local fname = Utilities.random_id()
        local nested = {}
        for j = 1, math.random(5, 12) do
            local nname = Utilities.random_id()
            table.insert(nested, "local function " .. nname .. "(x) return x + " .. math.random(1,999) .. " end")
        end
        local fcode = "local function " .. fname .. "(..." .. table.concat(nested, ";") .. "; local _=" .. math.random(1,999) .. "; return function() return _ end; end; " .. fname .. "(); "
        table.insert(dummy_funcs, fcode)
    end
    return table.concat(dummy_funcs) .. "\n" .. src
end

return DeadCode
