local Rename = {}
local Utilities = require("core.utilities")

function Rename.rename_identifiers_advanced(src)
    local keywords = {
        "and","break","do","else","elseif","end","false","for","function",
        "if","in","local","nil","not","or","repeat","return","then","true",
        "until","while","_G","_ENV","assert","collectgarbage","dofile",
        "error","getmetatable","ipairs","load","loadfile","next","pairs",
        "pcall","print","rawequal","rawget","rawlen","rawset","require",
        "select","setmetatable","tonumber","tostring","type","xpcall",
        "string","table","math","os","io","coroutine","package","debug",
        "bit","bit32","utf8","AT_CHECK"
    }
    local kw_set = {}
    for _, kw in ipairs(keywords) do kw_set[kw] = true end

    local mappings = {}
    local lines = {}
    for line in src:gmatch("[^\n]*") do
        local new_line = line:gsub("(%f[%a_]%a[%w_]*%f[^%w_])", function(word)
            if kw_set[word] then return word end
            if word:match("^_E$") or word:match("^_") then return word end
            if not mappings[word] then
                local new_name = Utilities.random_id()
                while kw_set[new_name] or mappings[word] == new_name or new_name:match("^_") do
                    new_name = Utilities.random_id()
                end
                mappings[word] = new_name
            end
            return mappings[word]
        end)
        lines[#lines+1] = new_line
    end
    return table.concat(lines, "\n")
end

return Rename
