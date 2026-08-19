local Utilities = {}

local _ID_SEEN = {}
local _ID_COUNTER = 0

function Utilities.random_id(prefix)
    local head_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    local body_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"
    local len = math.random(18, 35)
    local id
    repeat
        id = prefix or ""
        local first = math.random(1, #head_chars)
        id = id .. head_chars:sub(first, first)
        for i = 2, len do
            local idx = math.random(1, #body_chars)
            id = id .. body_chars:sub(idx, idx)
        end
        _ID_COUNTER = _ID_COUNTER + 1
        id = id .. "_" .. string.format("%x", (_ID_COUNTER * 2654435761) & 0xFFFFFF)
    until not _ID_SEEN[id]
    _ID_SEEN[id] = true
    return id
end

function Utilities.chaotic_hash(seed)
    seed = (seed ~ 61) & 0xFFFFFFFF
    seed = (seed + (seed << 3)) & 0xFFFFFFFF
    seed = seed ~ (seed >> 4)
    seed = (seed * 0x27d4eb2d) & 0xFFFFFFFF
    seed = seed ~ (seed >> 15)
    return seed
end

function Utilities.ultra_obfuscate_name()
    local seed = os.time() * 1000 + math.random(1, 1000)
    local hash = Utilities.chaotic_hash(seed)
    local chars = {}
    for i = 1, math.random(12, 20) do
        table.insert(chars, string.char(65 + (hash % 26)))
        hash = ((hash << 7) | (hash >> (32 - 7))) & 0xFFFFFFFF
    end
    return table.concat(chars)
end

function Utilities.encode_state_ultra(state_id, seed1, seed2, seed3)
    local encoded = state_id
    encoded = encoded ~ seed1
    encoded = ((encoded << 11) | (encoded >> (32 - 11))) & 0xFFFFFFFF
    encoded = encoded ~ seed2
    encoded = ((encoded << 7) | (encoded >> (32 - 7))) & 0xFFFFFFFF
    encoded = encoded ~ seed3
    return encoded & 0xFFFFFFFF
end

function Utilities.decode_state_ultra(encoded, seed1, seed2, seed3)
    local decoded = encoded & 0xFFFFFFFF
    decoded = ((decoded >> 7) | (decoded << (32 - 7))) & 0xFFFFFFFF
    decoded = decoded ~ seed3
    decoded = ((decoded >> 11) | (decoded << (32 - 11))) & 0xFFFFFFFF
    decoded = decoded ~ seed2
    decoded = decoded ~ seed1
    return decoded
end

function Utilities.generate_trap_sequence(length)
    local traps = {}
    local base = math.random(1000000, 9999999)
    for i = 1, length do
        table.insert(traps, {
            value = (base + i * 1337) & 0xFFFFFFFF,
            prime = (base * 31 + i * 97) & 0xFFFFFFFF,
            checksum = ((base ~ i) * 257) & 0xFFFFFFFF
        })
    end
    return traps
end

function Utilities.rotate_left(n, b)
    return ((n << b) | (n >> (32 - b))) & 0xFFFFFFFF
end

function Utilities.rotate_right(n, b)
    return ((n >> b) | (n << (32 - b))) & 0xFFFFFFFF
end

function Utilities._fnv1a(s)
    local h = 0x811C9DC5
    for i = 1, string.len(s) do
        h = math.fmod((h ~ string.byte(s, i)) * 0x01000193, 0x100000000)
    end
    return math.floor(h < 0 and h + 0x100000000 or h)
end

function Utilities._djb2(s)
    local h = 5381
    for i = 1, string.len(s) do
        h = math.fmod(h * 33 ~ string.byte(s, i), 0x100000000)
    end
    return math.floor(h < 0 and h + 0x100000000 or h)
end

return Utilities
