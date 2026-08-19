local Encryption = {}

function Encryption.encrypt_strings_anti_logging(src)
    local function anti_log_repl(content)
        local layers = math.random(12, 20)
        local result = content
        for layer = 1, layers do
            local method = math.random(1, 15)
            if method == 1 then
                local keys = {}
                for i = 1, math.random(3, 8) do
                    keys[i] = math.random(1, 255)
                end
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    for k = 1, #keys do
                        byte = byte ~ keys[k]
                    end
                    bytes[i] = byte
                end
                result = "(function() local ks={" .. table.concat(keys, ",") .. "}; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; for k=1,#ks do x=x~ks[k]; end; s=s..string.char(x) end; return s end)()"
            elseif method == 2 then
                local custom_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local shuffled = {}
                local chars = {}
                for i = 1, #custom_chars do
                    chars[i] = custom_chars:sub(i, i)
                end
                for i = #chars, 2, -1 do
                    local j = math.random(1, i)
                    chars[i], chars[j] = chars[j], chars[i]
                end
                local alphabet = table.concat(chars)
                local b64 = ""
                for i = 1, #result, 3 do
                    local a, b, c = string.byte(result, i, i+2)
                    b64 = b64 .. alphabet:sub((a >> 2) + 1, (a >> 2) + 1)
                    if b then
                        b64 = b64 .. alphabet:sub(((a & 3) << 4 | b >> 4) + 1, ((a & 3) << 4 | b >> 4) + 1)
                        if c then
                            b64 = b64 .. alphabet:sub(((b & 15) << 2 | c >> 6) + 1, ((b & 15) << 2 | c >> 6) + 1)
                            b64 = b64 .. alphabet:sub((c & 63) + 1, (c & 63) + 1)
                        else
                            b64 = b64 .. alphabet:sub(((b & 15) << 2) + 1, ((b & 15) << 2) + 1) .. "="
                        end
                    else
                        b64 = b64 .. "=="
                    end
                end
                result = "(function() local t={};local d='';local s='" .. b64 .. "';local c='" .. alphabet .. "';for i=1,#s do local ch=s:sub(i,i);if ch~='=' then t[#t+1]=c:find(ch)-1 end end;for i=1,#t,4 do local a=t[i]<<2|t[i+1]>>4;local b=(t[i+1]&15)<<4|t[i+2]>>2;local c=(t[i+2]&3)<<6|t[i+3];d=d..string.char(a);if t[i+2] then d=d..string.char(b) end;if t[i+3] then d=d..string.char(c) end end;return d end)()"
            elseif method == 3 then
                local shifts = {}
                for i = 1, math.random(3, 7) do
                    shifts[i] = math.random(1, 25)
                end
                local rotated = ""
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    local shift = shifts[(i-1) % #shifts + 1]
                    if byte >= 65 and byte <= 90 then
                        byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then
                        byte = ((byte - 97 + shift) % 26) + 97
                    end
                    rotated = rotated .. string.char(byte)
                end
                result = "(function() local s='" .. rotated .. "';local r='';local shs={" .. table.concat(shifts, ",") .. "};for i=1,#s do local b=s:byte(i);local sh=shs[(i-1)%#shs+1];if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r end)()"
            elseif method == 4 then
                local key = math.random(1, 65535)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = ~byte
                    byte = (byte + (key & 0xFF)) & 0xFF
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=(b[i]-(k&0xFF))&0xFF; s=s..string.char(~x) end; return s end)()"
            elseif method == 5 then
                local parts = {}
                local num_parts = math.random(4, 9)
                local part_size = math.floor(#result / num_parts)
                for i = 1, num_parts do
                    local start = (i-1)*part_size + 1
                    local finish = (i == num_parts) and #result or i*part_size
                    parts[i] = string.reverse(result:sub(start, finish))
                end
                local order = {}
                for i = 1, #parts do
                    order[i] = i
                end
                for i = #order, 2, -1 do
                    local j = math.random(1, i)
                    order[i], order[j] = order[j], order[i]
                end
                local ordered_parts = {}
                for i, idx in ipairs(order) do
                    ordered_parts[i] = "'" .. parts[idx] .. "'"
                end
                result = "(function() return string.reverse(table.concat({" .. table.concat(ordered_parts, ",") .. "}, '')) end)()"
            elseif method == 6 then
                local coeffs = {}
                for i = 1, math.random(3, 6) do
                    coeffs[i] = math.random(1, 100)
                end
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    local poly = 0
                    for c = 1, #coeffs do
                        poly = poly + coeffs[c] * (i ^ c)
                    end
                    byte = (byte + poly) & 0xFF
                    bytes[i] = byte
                end
                result = "(function() local c={" .. table.concat(coeffs, ",") .. "}; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local poly=0; for c=1,#c do poly=poly+c[c]*(i^c) end; s=s..string.char((b[i]-poly)&0xFF) end; return s end)()"
            else
                local sub_methods = {}
                local num_methods = math.random(2, 5)
                for i = 1, num_methods do
                    sub_methods[i] = math.random(1, 9)
                end
                local final = result
                for _, method_id in ipairs(sub_methods) do
                    if method_id == 1 then
                        local key = math.random(1, 255)
                        local bytes = {}
                        for i = 1, #final do
                            bytes[i] = string.byte(final, i) ~ key
                        end
                        final = "local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end; return s"
                    elseif method_id == 2 then
                        final = "local s=string.reverse('" .. string.reverse(final) .. "'); return s"
                    elseif method_id == 3 then
                        local shift = math.random(1, 25)
                        local rotated = ""
                        for i = 1, #final do
                            local byte = string.byte(final, i)
                            if byte >= 65 and byte <= 90 then
                                byte = ((byte - 65 + shift) % 26) + 65
                            elseif byte >= 97 and byte <= 122 then
                                byte = ((byte - 97 + shift) % 26) + 97
                            end
                            rotated = rotated .. string.char(byte)
                        end
                        final = "local s='" .. rotated .. "';local r='';local sh=" .. shift .. ";for i=1,#s do local b=s:byte(i);if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r"
                    end
                end
                result = "(function() " .. final .. " end)()"
            end
        end
        return result
    end
    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == "-" and src:sub(i + 1, i + 1) == "-" then
            local eq = src:match("^%-%-%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                local nl = src:find("\n", i, true)
                local stop = nl or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            end
        elseif c == "[" then
            local eq = src:match("^%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                out[#out + 1] = c
                i = i + 1
            end
        elseif c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = anti_log_repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.encrypt_strings_advanced(src)
    local function repl(content)
        local layers = math.random(8, 15)
        local result = content
        for layer = 1, layers do
            local method = math.random(1, 10)
            if method == 1 then
                local key = math.random(1, 255)
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = string.byte(result, i) ~ key
                end
                result = "(function() local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end return s end)()"
            elseif method == 2 then
                local custom_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local b64 = ""
                for i = 1, #result, 3 do
                    local a, b, c = string.byte(result, i, i+2)
                    b64 = b64 .. custom_chars:sub((a >> 2) + 1, (a >> 2) + 1)
                    if b then
                        b64 = b64 .. custom_chars:sub(((a & 3) << 4 | b >> 4) + 1, ((a & 3) << 4 | b >> 4) + 1)
                        if c then
                            b64 = b64 .. custom_chars:sub(((b & 15) << 2 | c >> 6) + 1, ((b & 15) << 2 | c >> 6) + 1)
                            b64 = b64 .. custom_chars:sub((c & 63) + 1, (c & 63) + 1)
                        else
                            b64 = b64 .. custom_chars:sub(((b & 15) << 2) + 1, ((b & 15) << 2) + 1) .. "="
                        end
                    else
                        b64 = b64 .. "=="
                    end
                end
                result = "(function() local t={};local d='';local s='" .. b64 .. "';local c='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';for i=1,#s do local ch=s:sub(i,i);if ch~='=' then t[#t+1]=c:find(ch)-1 end end;for i=1,#t,4 do local a=t[i]<<2|t[i+1]>>4;local b=(t[i+1]&15)<<4|t[i+2]>>2;local c=(t[i+2]&3)<<6|t[i+3];d=d..string.char(a);if t[i+2] then d=d..string.char(b) end;if t[i+3] then d=d..string.char(c) end end;return d end)()"
            elseif method == 3 then
                local shift = math.random(1, 25)
                local rotated = ""
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    if byte >= 65 and byte <= 90 then
                        byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then
                        byte = ((byte - 97 + shift) % 26) + 97
                    end
                    rotated = rotated .. string.char(byte)
                end
                result = "(function() local s='" .. rotated .. "';local r='';local sh=" .. shift .. ";for i=1,#s do local b=s:byte(i);if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r end)()"
            elseif method == 4 then
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = ~string.byte(result, i)
                end
                result = "(function() local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(~b[i]) end return s end)()"
            elseif method == 5 then
                local reversed = string.reverse(result)
                result = "(function() local s='" .. reversed .. "'; return string.reverse(s) end)()"
            elseif method == 6 then
                local key = math.random(1, 255)
                local shift = math.random(1, 25)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = (byte ~ key)
                    if byte >= 65 and byte <= 90 then byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then byte = ((byte - 97 + shift) % 26) + 97
                    end
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local sh=" .. shift .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; x=x~k; if x>=65 and x<=90 then x=((x-65-sh+26)%26)+65; elseif x>=97 and x<=122 then x=((x-97-sh+26)%26)+97; end; s=s..string.char(x) end; return s end)()"
            elseif method == 7 then
                local parts = {}
                local num_parts = math.random(3, 7)
                local step = math.floor(#result / num_parts)
                for i = 1, num_parts do
                    local start = (i-1)*step + 1
                    local finish = (i == num_parts) and #result or i*step
                    parts[i] = "'" .. result:sub(start, finish) .. "'"
                end
                result = "(function() return table.concat({" .. table.concat(parts, ",") .. "}, '') end)()"
            elseif method == 8 then
                local key_expr = "((" .. math.random(10, 99) .. "*" .. math.random(2, 9) .. ")^2 + " .. math.random(1, 100) .. ") % 255 + 1"
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = string.byte(result, i) ~ 42
                end
                result = "(function() local k=" .. key_expr .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end; return s end)()"
            elseif method == 9 then
                local key = math.random(1, 255)
                local iv = math.random(1, 255)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = (byte ~ (key + i)) ~ iv
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local iv=" .. iv .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; x=(x~iv)~(k+i); s=s..string.char(x) end; return s end)()"
            else
                local layers2 = math.random(2, 4)
                local final = result
                for l = 1, layers2 do
                    local key = math.random(1, 255)
                    local bytes = {}
                    for i = 1, #final do
                        bytes[i] = string.byte(final, i) ~ key
                    end
                    final = table.concat(bytes, ",")
                end
                result = "(function() local b={" .. final .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]) end; return s end)()"
            end
        end
        return result
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == "-" and src:sub(i + 1, i + 1) == "-" then
            local eq = src:match("^%-%-%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                local nl = src:find("\n", i, true)
                local stop = nl or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            end
        elseif c == "[" then
            local eq = src:match("^%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                out[#out + 1] = c
                i = i + 1
            end
        elseif c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.encrypt_numbers_advanced(src)
    local function build_expr(val, depth)
        if depth <= 0 then return tostring(val) end
        local ops = {"+", "-", "*", "//", "%", "^", "&", "|", "<<"}
        local op = ops[math.random(#ops)]
        if op == "+" then
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "-" then
            local a = math.random(1, 100)
            return "(" .. build_expr(a+val, depth-1) .. "-" .. build_expr(a, depth-1) .. ")"
        elseif op == "*" then
            local divisors = {}
            for i = 1, math.abs(val) do if val % i == 0 then table.insert(divisors, i) end end
            if #divisors > 0 then
                local d = divisors[math.random(#divisors)]
                if d ~= 0 then return "(" .. build_expr(d, depth-1) .. "*" .. build_expr(val//d, depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "//" then
            if val ~= 0 then
                local d = math.random(1, math.abs(val))
                if d ~= 0 then return "(" .. build_expr(val*d, depth-1) .. "//" .. build_expr(d, depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "%" then
            if val ~= 0 then
                local d = math.random(1, math.abs(val))
                if d ~= 0 then return "(" .. build_expr(val*d, depth-1) .. "%" .. build_expr((val*d)-(val), depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "^" then
            local base = math.random(2, 6)
            local exp = math.random(1, 4)
            return "((" .. build_expr(base, depth-1) .. ")^" .. exp .. "+" .. build_expr(val - base^exp, depth-1) .. ")"
        elseif op == "&" then
            local a = math.random(1, 255)
            local b = val & a
            return "((" .. build_expr(a, depth-1) .. "&" .. build_expr(b, depth-1) .. "))"
        elseif op == "|" then
            local a = math.random(1, 255)
            local b = val | a
            return "((" .. build_expr(a, depth-1) .. "|" .. build_expr(b, depth-1) .. "))"
        elseif op == "<<" then
            local shift = math.random(1, 5)
            local a = val >> shift
            return "((" .. build_expr(a, depth-1) .. "<<" .. shift .. "))"
        else
            return "(" .. build_expr(math.random(1, 100), depth-1) .. "+" .. build_expr(val-math.random(1, 100), depth-1) .. ")"
        end
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local s, e = src:find("%f[%w_]%d+%f[^%w_]", i)
        if not s then
            out[#out + 1] = src:sub(i)
            break
        end
        out[#out + 1] = src:sub(i, s - 1)
        local before = s > 1 and src:sub(s - 1, s - 1) or ""
        local after = e < len and src:sub(e + 1, e + 1) or ""
        local numstr = src:sub(s, e)
        if before == "." or after == "." then
            out[#out + 1] = numstr
        else
            local n = tonumber(numstr)
            if n and math.abs(n) < 1000000000 then
                out[#out + 1] = build_expr(n, math.random(4, 8))
            else
                out[#out + 1] = numstr
            end
        end
        i = e + 1
    end
    return table.concat(out)
end

function Encryption.split_strings_advanced(src)
    local function split_repl(content)
        local parts = {}
        local part_count = math.random(3, 8)
        local total_len = #content
        local seg_len = math.floor(total_len / part_count)
        for i = 1, part_count do
            local start = (i-1)*seg_len + 1
            local finish = (i == part_count) and total_len or start + seg_len - 1
            if finish >= start then
                table.insert(parts, string.format("'%s'", content:sub(start, finish)))
            end
        end
        local shuffle_order = {}
        for i = 1, #parts do shuffle_order[i] = i end
        for i = #shuffle_order, 2, -1 do
            local j = math.random(1, i)
            shuffle_order[i], shuffle_order[j] = shuffle_order[j], shuffle_order[i]
        end
        local shuffled_parts = {}
        for _, idx in ipairs(shuffle_order) do
            table.insert(shuffled_parts, parts[idx])
        end
        return "(function() local t={" .. table.concat(shuffled_parts, ",") .. "}; local order={" .. table.concat(shuffle_order, ",") .. "}; local s=''; for _,i in ipairs(order) do s=s..t[i] end; return s end)()"
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = split_repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.full_script_encryption_advanced(src)
    local key = math.random(1, 255)
    local encrypted = ""
    for i = 1, #src do
        encrypted = encrypted .. string.format("%02x", string.byte(src, i) ~ key)
    end
    local wrapper = string.format([[
local function _decrypt(k, h)
    local s=''
    for i=1,#h,2 do
        s=s..string.char(tonumber(h:sub(i,i+1),16)~k)
    end
    return s
end
local _code = _decrypt(%d, '%s')
local _ok, _err = pcall(function()
    local _fn, _msg = loadstring(_code)
    if not _fn then error(_msg) end
    _fn()
end)
if not _ok then
    local _ = {}
    for i=1,1000 do _[i] = math.random() end
    error('Execution failed')
end
]], key, encrypted)
    return wrapper
end

return Encryptionlocal Encryption = {}

function Encryption.encrypt_strings_anti_logging(src)
    local function anti_log_repl(content)
        local layers = math.random(12, 20)
        local result = content
        for layer = 1, layers do
            local method = math.random(1, 15)
            if method == 1 then
                local keys = {}
                for i = 1, math.random(3, 8) do
                    keys[i] = math.random(1, 255)
                end
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    for k = 1, #keys do
                        byte = byte ~ keys[k]
                    end
                    bytes[i] = byte
                end
                result = "(function() local ks={" .. table.concat(keys, ",") .. "}; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; for k=1,#ks do x=x~ks[k]; end; s=s..string.char(x) end; return s end)()"
            elseif method == 2 then
                local custom_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local shuffled = {}
                local chars = {}
                for i = 1, #custom_chars do
                    chars[i] = custom_chars:sub(i, i)
                end
                for i = #chars, 2, -1 do
                    local j = math.random(1, i)
                    chars[i], chars[j] = chars[j], chars[i]
                end
                local alphabet = table.concat(chars)
                local b64 = ""
                for i = 1, #result, 3 do
                    local a, b, c = string.byte(result, i, i+2)
                    b64 = b64 .. alphabet:sub((a >> 2) + 1, (a >> 2) + 1)
                    if b then
                        b64 = b64 .. alphabet:sub(((a & 3) << 4 | b >> 4) + 1, ((a & 3) << 4 | b >> 4) + 1)
                        if c then
                            b64 = b64 .. alphabet:sub(((b & 15) << 2 | c >> 6) + 1, ((b & 15) << 2 | c >> 6) + 1)
                            b64 = b64 .. alphabet:sub((c & 63) + 1, (c & 63) + 1)
                        else
                            b64 = b64 .. alphabet:sub(((b & 15) << 2) + 1, ((b & 15) << 2) + 1) .. "="
                        end
                    else
                        b64 = b64 .. "=="
                    end
                end
                result = "(function() local t={};local d='';local s='" .. b64 .. "';local c='" .. alphabet .. "';for i=1,#s do local ch=s:sub(i,i);if ch~='=' then t[#t+1]=c:find(ch)-1 end end;for i=1,#t,4 do local a=t[i]<<2|t[i+1]>>4;local b=(t[i+1]&15)<<4|t[i+2]>>2;local c=(t[i+2]&3)<<6|t[i+3];d=d..string.char(a);if t[i+2] then d=d..string.char(b) end;if t[i+3] then d=d..string.char(c) end end;return d end)()"
            elseif method == 3 then
                local shifts = {}
                for i = 1, math.random(3, 7) do
                    shifts[i] = math.random(1, 25)
                end
                local rotated = ""
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    local shift = shifts[(i-1) % #shifts + 1]
                    if byte >= 65 and byte <= 90 then
                        byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then
                        byte = ((byte - 97 + shift) % 26) + 97
                    end
                    rotated = rotated .. string.char(byte)
                end
                result = "(function() local s='" .. rotated .. "';local r='';local shs={" .. table.concat(shifts, ",") .. "};for i=1,#s do local b=s:byte(i);local sh=shs[(i-1)%#shs+1];if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r end)()"
            elseif method == 4 then
                local key = math.random(1, 65535)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = ~byte
                    byte = (byte + (key & 0xFF)) & 0xFF
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=(b[i]-(k&0xFF))&0xFF; s=s..string.char(~x) end; return s end)()"
            elseif method == 5 then
                local parts = {}
                local num_parts = math.random(4, 9)
                local part_size = math.floor(#result / num_parts)
                for i = 1, num_parts do
                    local start = (i-1)*part_size + 1
                    local finish = (i == num_parts) and #result or i*part_size
                    parts[i] = string.reverse(result:sub(start, finish))
                end
                local order = {}
                for i = 1, #parts do
                    order[i] = i
                end
                for i = #order, 2, -1 do
                    local j = math.random(1, i)
                    order[i], order[j] = order[j], order[i]
                end
                local ordered_parts = {}
                for i, idx in ipairs(order) do
                    ordered_parts[i] = "'" .. parts[idx] .. "'"
                end
                result = "(function() return string.reverse(table.concat({" .. table.concat(ordered_parts, ",") .. "}, '')) end)()"
            elseif method == 6 then
                local coeffs = {}
                for i = 1, math.random(3, 6) do
                    coeffs[i] = math.random(1, 100)
                end
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    local poly = 0
                    for c = 1, #coeffs do
                        poly = poly + coeffs[c] * (i ^ c)
                    end
                    byte = (byte + poly) & 0xFF
                    bytes[i] = byte
                end
                result = "(function() local c={" .. table.concat(coeffs, ",") .. "}; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local poly=0; for c=1,#c do poly=poly+c[c]*(i^c) end; s=s..string.char((b[i]-poly)&0xFF) end; return s end)()"
            else
                local sub_methods = {}
                local num_methods = math.random(2, 5)
                for i = 1, num_methods do
                    sub_methods[i] = math.random(1, 9)
                end
                local final = result
                for _, method_id in ipairs(sub_methods) do
                    if method_id == 1 then
                        local key = math.random(1, 255)
                        local bytes = {}
                        for i = 1, #final do
                            bytes[i] = string.byte(final, i) ~ key
                        end
                        final = "local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end; return s"
                    elseif method_id == 2 then
                        final = "local s=string.reverse('" .. string.reverse(final) .. "'); return s"
                    elseif method_id == 3 then
                        local shift = math.random(1, 25)
                        local rotated = ""
                        for i = 1, #final do
                            local byte = string.byte(final, i)
                            if byte >= 65 and byte <= 90 then
                                byte = ((byte - 65 + shift) % 26) + 65
                            elseif byte >= 97 and byte <= 122 then
                                byte = ((byte - 97 + shift) % 26) + 97
                            end
                            rotated = rotated .. string.char(byte)
                        end
                        final = "local s='" .. rotated .. "';local r='';local sh=" .. shift .. ";for i=1,#s do local b=s:byte(i);if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r"
                    end
                end
                result = "(function() " .. final .. " end)()"
            end
        end
        return result
    end
    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == "-" and src:sub(i + 1, i + 1) == "-" then
            local eq = src:match("^%-%-%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                local nl = src:find("\n", i, true)
                local stop = nl or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            end
        elseif c == "[" then
            local eq = src:match("^%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                out[#out + 1] = c
                i = i + 1
            end
        elseif c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = anti_log_repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.encrypt_strings_advanced(src)
    local function repl(content)
        local layers = math.random(8, 15)
        local result = content
        for layer = 1, layers do
            local method = math.random(1, 10)
            if method == 1 then
                local key = math.random(1, 255)
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = string.byte(result, i) ~ key
                end
                result = "(function() local k=" .. key .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end return s end)()"
            elseif method == 2 then
                local custom_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local b64 = ""
                for i = 1, #result, 3 do
                    local a, b, c = string.byte(result, i, i+2)
                    b64 = b64 .. custom_chars:sub((a >> 2) + 1, (a >> 2) + 1)
                    if b then
                        b64 = b64 .. custom_chars:sub(((a & 3) << 4 | b >> 4) + 1, ((a & 3) << 4 | b >> 4) + 1)
                        if c then
                            b64 = b64 .. custom_chars:sub(((b & 15) << 2 | c >> 6) + 1, ((b & 15) << 2 | c >> 6) + 1)
                            b64 = b64 .. custom_chars:sub((c & 63) + 1, (c & 63) + 1)
                        else
                            b64 = b64 .. custom_chars:sub(((b & 15) << 2) + 1, ((b & 15) << 2) + 1) .. "="
                        end
                    else
                        b64 = b64 .. "=="
                    end
                end
                result = "(function() local t={};local d='';local s='" .. b64 .. "';local c='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';for i=1,#s do local ch=s:sub(i,i);if ch~='=' then t[#t+1]=c:find(ch)-1 end end;for i=1,#t,4 do local a=t[i]<<2|t[i+1]>>4;local b=(t[i+1]&15)<<4|t[i+2]>>2;local c=(t[i+2]&3)<<6|t[i+3];d=d..string.char(a);if t[i+2] then d=d..string.char(b) end;if t[i+3] then d=d..string.char(c) end end;return d end)()"
            elseif method == 3 then
                local shift = math.random(1, 25)
                local rotated = ""
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    if byte >= 65 and byte <= 90 then
                        byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then
                        byte = ((byte - 97 + shift) % 26) + 97
                    end
                    rotated = rotated .. string.char(byte)
                end
                result = "(function() local s='" .. rotated .. "';local r='';local sh=" .. shift .. ";for i=1,#s do local b=s:byte(i);if b>=65 and b<=90 then b=((b-65-sh+26)%26)+65;elseif b>=97 and b<=122 then b=((b-97-sh+26)%26)+97;end;r=r..string.char(b) end;return r end)()"
            elseif method == 4 then
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = ~string.byte(result, i)
                end
                result = "(function() local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(~b[i]) end return s end)()"
            elseif method == 5 then
                local reversed = string.reverse(result)
                result = "(function() local s='" .. reversed .. "'; return string.reverse(s) end)()"
            elseif method == 6 then
                local key = math.random(1, 255)
                local shift = math.random(1, 25)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = (byte ~ key)
                    if byte >= 65 and byte <= 90 then byte = ((byte - 65 + shift) % 26) + 65
                    elseif byte >= 97 and byte <= 122 then byte = ((byte - 97 + shift) % 26) + 97
                    end
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local sh=" .. shift .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; x=x~k; if x>=65 and x<=90 then x=((x-65-sh+26)%26)+65; elseif x>=97 and x<=122 then x=((x-97-sh+26)%26)+97; end; s=s..string.char(x) end; return s end)()"
            elseif method == 7 then
                local parts = {}
                local num_parts = math.random(3, 7)
                local step = math.floor(#result / num_parts)
                for i = 1, num_parts do
                    local start = (i-1)*step + 1
                    local finish = (i == num_parts) and #result or i*step
                    parts[i] = "'" .. result:sub(start, finish) .. "'"
                end
                result = "(function() return table.concat({" .. table.concat(parts, ",") .. "}, '') end)()"
            elseif method == 8 then
                local key_expr = "((" .. math.random(10, 99) .. "*" .. math.random(2, 9) .. ")^2 + " .. math.random(1, 100) .. ") % 255 + 1"
                local bytes = {}
                for i = 1, #result do
                    bytes[i] = string.byte(result, i) ~ 42
                end
                result = "(function() local k=" .. key_expr .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]~k) end; return s end)()"
            elseif method == 9 then
                local key = math.random(1, 255)
                local iv = math.random(1, 255)
                local bytes = {}
                for i = 1, #result do
                    local byte = string.byte(result, i)
                    byte = (byte ~ (key + i)) ~ iv
                    bytes[i] = byte
                end
                result = "(function() local k=" .. key .. "; local iv=" .. iv .. "; local b={" .. table.concat(bytes, ",") .. "}; local s=''; for i=1,#b do local x=b[i]; x=(x~iv)~(k+i); s=s..string.char(x) end; return s end)()"
            else
                local layers2 = math.random(2, 4)
                local final = result
                for l = 1, layers2 do
                    local key = math.random(1, 255)
                    local bytes = {}
                    for i = 1, #final do
                        bytes[i] = string.byte(final, i) ~ key
                    end
                    final = table.concat(bytes, ",")
                end
                result = "(function() local b={" .. final .. "}; local s=''; for i=1,#b do s=s..string.char(b[i]) end; return s end)()"
            end
        end
        return result
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == "-" and src:sub(i + 1, i + 1) == "-" then
            local eq = src:match("^%-%-%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                local nl = src:find("\n", i, true)
                local stop = nl or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            end
        elseif c == "[" then
            local eq = src:match("^%[(=*)%[", i)
            if eq then
                local closer = "]" .. eq .. "]"
                local s, e = src:find(closer, i, true)
                local stop = e and (e + 1) or (len + 1)
                out[#out + 1] = src:sub(i, stop - 1)
                i = stop
            else
                out[#out + 1] = c
                i = i + 1
            end
        elseif c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.encrypt_numbers_advanced(src)
    local function build_expr(val, depth)
        if depth <= 0 then return tostring(val) end
        local ops = {"+", "-", "*", "//", "%", "^", "&", "|", "<<"}
        local op = ops[math.random(#ops)]
        if op == "+" then
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "-" then
            local a = math.random(1, 100)
            return "(" .. build_expr(a+val, depth-1) .. "-" .. build_expr(a, depth-1) .. ")"
        elseif op == "*" then
            local divisors = {}
            for i = 1, math.abs(val) do if val % i == 0 then table.insert(divisors, i) end end
            if #divisors > 0 then
                local d = divisors[math.random(#divisors)]
                if d ~= 0 then return "(" .. build_expr(d, depth-1) .. "*" .. build_expr(val//d, depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "//" then
            if val ~= 0 then
                local d = math.random(1, math.abs(val))
                if d ~= 0 then return "(" .. build_expr(val*d, depth-1) .. "//" .. build_expr(d, depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "%" then
            if val ~= 0 then
                local d = math.random(1, math.abs(val))
                if d ~= 0 then return "(" .. build_expr(val*d, depth-1) .. "%" .. build_expr((val*d)-(val), depth-1) .. ")"
            end
            local a = math.random(1, 100)
            return "(" .. build_expr(a, depth-1) .. "+" .. build_expr(val-a, depth-1) .. ")"
        elseif op == "^" then
            local base = math.random(2, 6)
            local exp = math.random(1, 4)
            return "((" .. build_expr(base, depth-1) .. ")^" .. exp .. "+" .. build_expr(val - base^exp, depth-1) .. ")"
        elseif op == "&" then
            local a = math.random(1, 255)
            local b = val & a
            return "((" .. build_expr(a, depth-1) .. "&" .. build_expr(b, depth-1) .. "))"
        elseif op == "|" then
            local a = math.random(1, 255)
            local b = val | a
            return "((" .. build_expr(a, depth-1) .. "|" .. build_expr(b, depth-1) .. "))"
        elseif op == "<<" then
            local shift = math.random(1, 5)
            local a = val >> shift
            return "((" .. build_expr(a, depth-1) .. "<<" .. shift .. "))"
        else
            return "(" .. build_expr(math.random(1, 100), depth-1) .. "+" .. build_expr(val-math.random(1, 100), depth-1) .. ")"
        end
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local s, e = src:find("%f[%w_]%d+%f[^%w_]", i)
        if not s then
            out[#out + 1] = src:sub(i)
            break
        end
        out[#out + 1] = src:sub(i, s - 1)
        local before = s > 1 and src:sub(s - 1, s - 1) or ""
        local after = e < len and src:sub(e + 1, e + 1) or ""
        local numstr = src:sub(s, e)
        if before == "." or after == "." then
            out[#out + 1] = numstr
        else
            local n = tonumber(numstr)
            if n and math.abs(n) < 1000000000 then
                out[#out + 1] = build_expr(n, math.random(4, 8))
            else
                out[#out + 1] = numstr
            end
        end
        i = e + 1
    end
    return table.concat(out)
end

function Encryption.split_strings_advanced(src)
    local function split_repl(content)
        local parts = {}
        local part_count = math.random(3, 8)
        local total_len = #content
        local seg_len = math.floor(total_len / part_count)
        for i = 1, part_count do
            local start = (i-1)*seg_len + 1
            local finish = (i == part_count) and total_len or start + seg_len - 1
            if finish >= start then
                table.insert(parts, string.format("'%s'", content:sub(start, finish)))
            end
        end
        local shuffle_order = {}
        for i = 1, #parts do shuffle_order[i] = i end
        for i = #shuffle_order, 2, -1 do
            local j = math.random(1, i)
            shuffle_order[i], shuffle_order[j] = shuffle_order[j], shuffle_order[i]
        end
        local shuffled_parts = {}
        for _, idx in ipairs(shuffle_order) do
            table.insert(shuffled_parts, parts[idx])
        end
        return "(function() local t={" .. table.concat(shuffled_parts, ",") .. "}; local order={" .. table.concat(shuffle_order, ",") .. "}; local s=''; for _,i in ipairs(order) do s=s..t[i] end; return s end)()"
    end

    local out = {}
    local i = 1
    local len = #src
    while i <= len do
        local c = src:sub(i, i)
        if c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = {}
            while j <= len do
                local cj = src:sub(j, j)
                if cj == "\\" then
                    buf[#buf + 1] = src:sub(j, j + 1)
                    j = j + 2
                elseif cj == quote then
                    j = j + 1
                    break
                elseif cj == "\n" or cj == "" then
                    break
                else
                    buf[#buf + 1] = cj
                    j = j + 1
                end
            end
            local content = table.concat(buf)
            if content:find("\\") then
                out[#out + 1] = quote .. content .. quote
            else
                out[#out + 1] = split_repl(content)
            end
            i = j
        else
            out[#out + 1] = c
            i = i + 1
        end
    end
    return table.concat(out)
end

function Encryption.full_script_encryption_advanced(src)
    local key = math.random(1, 255)
    local encrypted = ""
    for i = 1, #src do
        encrypted = encrypted .. string.format("%02x", string.byte(src, i) ~ key)
    end
    local wrapper = string.format([[
local function _decrypt(k, h)
    local s=''
    for i=1,#h,2 do
        s=s..string.char(tonumber(h:sub(i,i+1),16)~k)
    end
    return s
end
local _code = _decrypt(%d, '%s')
local _ok, _err = pcall(function()
    local _fn, _msg = loadstring(_code)
    if not _fn then error(_msg) end
    _fn()
end)
if not _ok then
    local _ = {}
    for i=1,1000 do _[i] = math.random() end
    error('Execution failed')
end
]], key, encrypted)
    return wrapper
end

return Encryption
