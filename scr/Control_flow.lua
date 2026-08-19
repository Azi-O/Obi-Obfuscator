local ControlFlow = {}
local Utilities = require("core.utilities")

local function flatten_control_flow_v5_ultimate(source_code)
    local lines = {}
    for line in string.gmatch(source_code, "[^\r\n]+") do
        line = string.gsub(line, "^%s*(.-)%s*$", "%1")
        if line ~= "" then
            table.insert(lines, line)
        end
    end

    if #lines == 0 then return source_code end

    math.randomseed(os.time() + math.floor(math.random() * 100000))

    local seed1 = math.random(1000000, 9999999)
    local seed2 = math.random(1000000, 9999999)
    local seed3 = math.random(1000000, 9999999)

    local order = {}
    for i = 1, #lines do
        table.insert(order, i)
    end

    for i = #order, 2, -1 do
        local j = math.random(1, i)
        order[i], order[j] = order[j], order[i]
    end

    local cases = {}

    for i = 1, #lines do
        local current_state = order[i]
        local next_state = order[i + 1] or -1

        local encoded_current = Utilities.encode_state_ultra(current_state, seed1, seed2, seed3)
        local encoded_next = Utilities.encode_state_ultra(next_state, seed1, seed2, seed3)

        cases[current_state] = {
            code = lines[i],
            next_state = next_state,
            encoded_current = encoded_current,
            encoded_next = encoded_next
        }
    end

    local dead_blocks = {}
    for _ = 1, math.max(3, #lines // 2) do
        local dead_id = math.random(100000, 999999)
        local dead_next = math.random(100000, 999999)
        local trap_seq = Utilities.generate_trap_sequence(math.random(5, 10))

        dead_blocks[dead_id] = {
            code = "",
            next_state = dead_next,
            encoded_current = Utilities.encode_state_ultra(dead_id, seed1, seed2, seed3),
            encoded_next = Utilities.encode_state_ultra(dead_next, seed1, seed2, seed3),
            trap_sequence = trap_seq
        }

        table.insert(order, dead_id)
        cases[dead_id] = dead_blocks[dead_id]
    end

    local v_state = Utilities.ultra_obfuscate_name()
    local v_loop = Utilities.ultra_obfuscate_name()
    local v_seed1 = Utilities.ultra_obfuscate_name()
    local v_seed2 = Utilities.ultra_obfuscate_name()
    local v_seed3 = Utilities.ultra_obfuscate_name()
    local v_decoded = Utilities.ultra_obfuscate_name()
    local v_counter = Utilities.ultra_obfuscate_name()
    local v_trap = Utilities.ultra_obfuscate_name()
    local v_dispatch = Utilities.ultra_obfuscate_name()

    local obfuscated = {}

    table.insert(obfuscated, "local " .. v_seed1 .. " = " .. seed1)
    table.insert(obfuscated, "local " .. v_seed2 .. " = " .. seed2)
    table.insert(obfuscated, "local " .. v_seed3 .. " = " .. seed3)
    table.insert(obfuscated, "")

    table.insert(obfuscated, "local " .. v_trap .. " = {}")
    for i, trap_seq in pairs(dead_blocks) do
        for j, trap in ipairs(trap_seq.trap_sequence) do
            table.insert(obfuscated, v_trap .. "[" .. i .. "_" .. j .. "] = " .. trap.checksum)
        end
    end
    table.insert(obfuscated, "")

    table.insert(obfuscated, "local " .. v_dispatch .. " = {}")
    for i, state_id in ipairs(order) do
        local data = cases[state_id]
        if data then
            table.insert(obfuscated, v_dispatch .. "[" .. state_id .. "] = function()")
            if data.code and data.code ~= "" then
                table.insert(obfuscated, "    " .. data.code)
            end
            if data.next_state == -1 then
                table.insert(obfuscated, "    return nil")
            else
                local a = math.random(1, 1000)
                local b = math.random(1, 1000)
                local calc = "(" .. a .. " * " .. b .. " + " .. (data.encoded_next - a * b) .. ")"
                table.insert(obfuscated, "    return " .. calc)
            end
            table.insert(obfuscated, "end")
        end
    end
    table.insert(obfuscated, "")

    table.insert(obfuscated, "local " .. v_state .. " = " .. cases[order[1]].encoded_current)
    table.insert(obfuscated, "local " .. v_loop .. " = 1")
    table.insert(obfuscated, "local " .. v_counter .. " = 0")
    table.insert(obfuscated, "")

    table.insert(obfuscated, "while " .. v_state .. " and " .. v_loop .. " < 10000 do")
    table.insert(obfuscated, "    " .. v_counter .. " = " .. v_counter .. " + 1")
    table.insert(obfuscated, "    local " .. v_decoded .. " = " .. v_state .. " ~ " .. v_seed1)
    table.insert(obfuscated, "    " .. v_decoded .. " = ((" .. v_decoded .. " >> 11) | (" .. v_decoded .. " << (32 - 11))) & 0xFFFFFFFF")
    table.insert(obfuscated, "    " .. v_decoded .. " = " .. v_decoded .. " ~ " .. v_seed2)
    table.insert(obfuscated, "    " .. v_decoded .. " = ((" .. v_decoded .. " >> 7) | (" .. v_decoded .. " << (32 - 7))) & 0xFFFFFFFF")
    table.insert(obfuscated, "    " .. v_decoded .. " = " .. v_decoded .. " ~ " .. v_seed3)
    table.insert(obfuscated, "    if " .. v_dispatch .. "[" .. v_decoded .. "] then")
    table.insert(obfuscated, "        " .. v_state .. " = " .. v_dispatch .. "[" .. v_decoded .. "]()")
    table.insert(obfuscated, "    else")
    table.insert(obfuscated, "        break")
    table.insert(obfuscated, "    end")
    table.insert(obfuscated, "end")

    return table.concat(obfuscated, "\n")
end

local function flatten_control_flow_v6_hyperbolic(source_code)
    local lines = {}
    for line in string.gmatch(source_code, "[^\r\n]+") do
        line = string.gsub(line, "^%s*(.-)%s*$", "%1")
        if line ~= "" then
            table.insert(lines, line)
        end
    end

    if #lines == 0 then return source_code end

    math.randomseed(os.time() + math.floor(math.random() * 100000))

    local order = {}
    for i = 1, #lines do
        table.insert(order, i)
    end

    for i = #order, 2, -1 do
        local j = math.random(1, i)
        order[i], order[j] = order[j], order[i]
    end

    local v_coroutines = Utilities.ultra_obfuscate_name()
    local v_coro = Utilities.ultra_obfuscate_name()
    local v_status = Utilities.ultra_obfuscate_name()
    local v_result = Utilities.ultra_obfuscate_name()

    local obfuscated = {}

    table.insert(obfuscated, "local " .. v_coroutines .. " = {}")
    table.insert(obfuscated, "")

    for i, line_idx in ipairs(order) do
        table.insert(obfuscated, v_coroutines .. "[" .. i .. "] = coroutine.create(function()")
        table.insert(obfuscated, "    " .. lines[line_idx])
        table.insert(obfuscated, "    coroutine.yield()")
        table.insert(obfuscated, "end)")
    end

    table.insert(obfuscated, "")
    table.insert(obfuscated, "local " .. v_coro .. " = " .. v_coroutines .. "[1]")
    table.insert(obfuscated, "")

    table.insert(obfuscated, "for _ = 1, #" .. v_coroutines .. " do")
    table.insert(obfuscated, "    local " .. v_status .. ", " .. v_result .. " = coroutine.resume(" .. v_coro .. ")")
    table.insert(obfuscated, "    if not " .. v_status .. " then break end")
    table.insert(obfuscated, "    local _idx = nil")
    table.insert(obfuscated, "    for i, coro in ipairs(" .. v_coroutines .. ") do")
    table.insert(obfuscated, "        if coro == " .. v_coro .. " and i < #" .. v_coroutines .. " then")
    table.insert(obfuscated, "            " .. v_coro .. " = " .. v_coroutines .. "[i + 1]")
    table.insert(obfuscated, "        end")
    table.insert(obfuscated, "    end")
    table.insert(obfuscated, "end")

    return table.concat(obfuscated, "\n")
end

local function flatten_control_flow_v7_quantum_chaos(source_code)
    local lines = {}
    for line in string.gmatch(source_code, "[^\r\n]+") do
        line = string.gsub(line, "^%s*(.-)%s*$", "%1")
        if line ~= "" then
            table.insert(lines, line)
        end
    end

    if #lines == 0 then return source_code end

    math.randomseed(os.time() + math.floor(math.random() * 100000))

    local shuffles = {}
    for _ = 1, 3 do
        local order = {}
        for i = 1, #lines do
            table.insert(order, i)
        end
        for i = #order, 2, -1 do
            local j = math.random(1, i)
            order[i], order[j] = order[j], order[i]
        end
        table.insert(shuffles, order)
    end

    local var_shuf1 = Utilities.ultra_obfuscate_name()
    local var_shuf2 = Utilities.ultra_obfuscate_name()
    local var_shuf3 = Utilities.ultra_obfuscate_name()
    local var_idx = Utilities.ultra_obfuscate_name()
    local var_chaos = Utilities.ultra_obfuscate_name()

    local obfuscated = {}

    table.insert(obfuscated, "local " .. var_shuf1 .. " = {" .. table.concat(shuffles[1], ", ") .. "}")
    table.insert(obfuscated, "local " .. var_shuf2 .. " = {" .. table.concat(shuffles[2], ", ") .. "}")
    table.insert(obfuscated, "local " .. var_shuf3 .. " = {" .. table.concat(shuffles[3], ", ") .. "}")
    table.insert(obfuscated, "local " .. var_chaos .. " = {" .. var_shuf1 .. ", " .. var_shuf2 .. ", " .. var_shuf3 .. "}")
    table.insert(obfuscated, "")

    table.insert(obfuscated, "local " .. var_idx .. " = 1")
    table.insert(obfuscated, "local _chaos_selector = math.random(1, 3)")
    table.insert(obfuscated, "local _selected_order = " .. var_chaos .. "[_chaos_selector]")
    table.insert(obfuscated, "")

    table.insert(obfuscated, "while " .. var_idx .. " <= #_selected_order do")
    table.insert(obfuscated, "    local _line_num = _selected_order[" .. var_idx .. "]")
    table.insert(obfuscated, "    " .. var_idx .. " = " .. var_idx .. " + 1")
    table.insert(obfuscated, "")

    table.insert(obfuscated, "    if _line_num == 1 then")
    table.insert(obfuscated, "        " .. lines[1])

    for i = 2, #lines do
        table.insert(obfuscated, "    elseif _line_num == " .. i .. " then")
        table.insert(obfuscated, "        " .. lines[i])
    end

    table.insert(obfuscated, "    end")
    table.insert(obfuscated, "end")

    return table.concat(obfuscated, "\n")
end

function ControlFlow.flatten_control_flow_v8_adaptive(source_code, options)
    options = options or {}
    local technique = options.technique or math.random(5, 7)

    if technique == 5 then
        return flatten_control_flow_v5_ultimate(source_code)
    elseif technique == 6 then
        return flatten_control_flow_v6_hyperbolic(source_code)
    elseif technique == 7 then
        return flatten_control_flow_v7_quantum_chaos(source_code)
    else
        local code = flatten_control_flow_v5_ultimate(source_code)
        if math.random() > 0.5 then
            return flatten_control_flow_v6_hyperbolic(code)
        end
        return code
    end
end

function ControlFlow.stack_multiple_layers(source_code, layers)
    layers = layers or 2
    local result = source_code
    for i = 1, layers do
        result = ControlFlow.flatten_control_flow_v8_adaptive(result)
    end
    return result
end

function ControlFlow.jump_table_control_flow(src)
    local lines = {}
    for line in src:gmatch("[^\n]*") do
        if not line:match("^%s*$") then
            table.insert(lines, line)
        end
    end
    if #lines == 0 then return src end
    local jump_table = {}
    for i, line in ipairs(lines) do
        jump_table[i] = line
    end
    local keys = {}
    for i = 1, #jump_table do keys[i] = i end
    for i = #keys, 2, -1 do
        local j = math.random(1, i)
        keys[i], keys[j] = keys[j], keys[i]
    end
    local jt_name = Utilities.random_id()
    local code = {}
    table.insert(code, "local " .. jt_name .. " = {")
    for _, k in ipairs(keys) do
        table.insert(code, string.format("    [%d] = function() %s end,", k, jump_table[k]))
    end
    table.insert(code, "}")
    local order = table.concat(keys, ",")
    table.insert(code, "local _order = {" .. order .. "}")
    table.insert(code, "for _idx = 1, #_order do")
    table.insert(code, "    local _func = " .. jt_name .. "[_order[_idx]]")
    table.insert(code, "    if _func then _func() end")
    table.insert(code, "end")
    return table.concat(code, "\n")
end

return ControlFlow
