local AntiTamper = {}

function AntiTamper.generate_advanced_anti_emulation_engine()
    return [[
local _A = {
    type             = type,
    rawget           = rawget,
    rawset           = rawset,
    rawequal         = rawequal,
    rawlen           = rawlen,
    pairs            = pairs,
    ipairs           = ipairs,
    next             = next,
    select           = select,
    pcall            = pcall,
    xpcall           = xpcall,
    error            = error,
    assert           = assert,
    tostring         = tostring,
    tonumber         = tonumber,
    setmetatable     = setmetatable,
    getmetatable     = getmetatable,
    string_byte      = string.byte,
    string_char      = string.char,
    string_len       = string.len,
    string_sub       = string.sub,
    string_rep       = string.rep,
    string_format    = string.format,
    string_find      = string.find,
    string_gmatch    = string.gmatch,
    string_gsub      = string.gsub,
    table_concat     = table.concat,
    table_insert     = table.insert,
    table_remove     = table.remove,
    table_sort       = table.sort,
    table_unpack     = table.unpack or unpack,
    math_floor       = math.floor,
    math_ceil        = math.ceil,
    math_abs         = math.abs,
    math_fmod        = math.fmod,
    math_random      = math.random,
    math_randomseed  = math.randomseed,
    math_huge        = math.huge,
    math_max         = math.max,
    math_min         = math.min,
    math_sqrt        = math.sqrt,
    os_clock         = os.clock,
    os_time          = os.time,
    os_exit          = os.exit,
    loadstring       = loadstring,
    loadfile         = loadfile,
    dofile           = dofile,
    debug_getinfo    = debug and debug.getinfo or nil,
    debug_gethook    = debug and debug.gethook or nil,
    debug_getupvalue = debug and debug.getupvalue or nil,
    debug_setupvalue = debug and debug.setupvalue or nil,
    debug_sethook    = debug and debug.sethook or nil,
    debug_getlocal   = debug and debug.getlocal or nil,
    debug_setlocal   = debug and debug.setlocal or nil,
    debug_getuservalue = debug and debug.getuservalue or nil,
    debug_setuservalue = debug and debug.setuservalue or nil,
    debug_upvalueid  = debug and debug.upvalueid or nil,
    debug_upvaluejoin = debug and debug.upvaluejoin or nil,
    coroutine_create = coroutine and coroutine.create or nil,
    coroutine_resume = coroutine and coroutine.resume or nil,
    coroutine_status = coroutine and coroutine.status or nil,
    coroutine_yield  = coroutine and coroutine.yield or nil,
    coroutine_wrap   = coroutine and coroutine.wrap or nil,
    collectgarbage   = collectgarbage,
    gcinfo           = gcinfo,
    _VERSION         = _VERSION,
}

_A.setmetatable(_A, {
    __newindex = function() _A.error("_A is sealed", 0) end,
    __index    = function(_, k) return nil end,
})

local _DEAD        = false
local _WD          = 0
local _LAST_CLOCK  = _A.os_clock()
local _CALL_LOG    = {}
local _RING_SIZE   = 32
local _RING_HEAD   = 0

local _ENV_FLAGS = {
    IS_LUNE        = false,
    IS_FAKE        = false,
    TRACE_LOG      = false,
    HOOKED         = false,
    DEBUGGER       = false,
    EMULATED       = false,
    SANDBOXED      = false,
    IS_LINUX_GAME  = false,
    IS_LINUX       = false,
    IS_WSL         = false,
    IS_DOCKER      = false,
    IS_PROXIED     = false,
    LOG_REDIRECTED = false,
    API_HOOKED     = false,
    IS_ANDROID     = false,
    IS_TERMUX      = false,
    IS_MACOS       = false,
    IS_FREEBSD     = false,
    IS_OPENBSD     = false,
    IS_NETBSD      = false,
    IS_CYGWIN      = false,
    IS_MSYS        = false,
    IS_BSD         = false,
    IS_SOLARIS     = false,
    IS_AIX         = false,
    IS_HPUX        = false,
    IS_ARM         = false,
    IS_X86         = false,
    IS_X64         = false,
    IS_32BIT       = false,
    IS_64BIT       = false,
    HAS_GPU        = false,
    HAS_X11        = false,
    HAS_WAYLAND    = false,
    IS_HEADLESS    = false,
    IS_CONTAINER   = false,
    IS_KUBERNETES  = false,
    IS_AWS         = false,
    IS_GCP         = false,
    IS_AZURE       = false,
    IS_VPS         = false,
    IS_VM          = false,
    IS_HYPERV      = false,
    IS_VMWARE      = false,
    IS_VIRTUALBOX  = false,
    IS_KVM         = false,
    IS_XEN         = false,
    IS_QEMU        = false,
    IS_PROOT       = false,
    IS_CHROOT      = false,
    IS_NAMESPACE   = false,
    IS_JAIL        = false,
    IS_CGROUP      = false,
    IS_LXC         = false,
    IS_LXD         = false,
    IS_PODMAN      = false,
    IS_RUNC        = false,
    IS_CRIO        = false,
    IS_FIREJAIL    = false,
    IS_BWRAP       = false,
    IS_SNAP        = false,
    IS_FLATPAK     = false,
    IS_APPIMAGE    = false,
    IS_SANDBOX     = false,
    IS_DEBUG       = false,
    IS_PROFILER    = false,
    IS_INSTRUMENT  = false,
    IS_DTRACE      = false,
    IS_SYSTRACE    = false,
    IS_GDB         = false,
    IS_LLDB        = false,
    IS_VALGRIND    = false,
    IS_HELGRIND    = false,
    IS_DRMEMORY    = false,
    IS_ADDR2LINE   = false,
    IS_OBJDUMP     = false,
    IS_READELF     = false,
    IS_NM          = false,
    IS_STRINGS     = false,
    IS_LDD         = false,
    IS_LSOF        = false,
    IS_PS          = false,
    IS_TOP         = false,
    IS_HT          = false,
    IS_STRACE      = false,
    IS_LTRACE      = false,
    IS_PERF        = false,
    IS_SYSTEMD     = false,
    IS_UPSTART     = false,
    IS_SYSV        = false,
    IS_OPENRC      = false,
    IS_RUNIT       = false,
    IS_S6          = false,
    IS_LAUNCHD     = false,
    IS_SMCFS       = false,
    IS_NFS         = false,
    IS_CIFS        = false,
    IS_FUSE        = false,
    IS_OVERLAY     = false,
    IS_AUFS        = false,
    IS_DEVICEMAPPER = false,
    IS_ZFS         = false,
    IS_BTRFS       = false,
    IS_XFS         = false,
    IS_EXT4        = false,
    IS_EXT3        = false,
    IS_EXT2        = false,
    IS_FAT         = false,
    IS_NTFS        = false,
    IS_HFS         = false,
    IS_APFS        = false,
    IS_PROC        = false,
    IS_SYSFS       = false,
    IS_DEVPTS      = false,
    IS_SHM         = false,
    IS_TMPFS       = false,
    IS_SWAP        = false,
    IS_LOOP        = false,
    IS_CRYPT       = false,
    IS_LVM         = false,
    IS_RAID        = false,
    IS_ISCSI       = false,
    IS_FC          = false,
    IS_SAS         = false,
    IS_SATA        = false,
    IS_NVME        = false,
    IS_MMC         = false,
    IS_SD          = false,
    IS_USB         = false,
    IS_THUNDERBOLT = false,
    IS_PCI         = false,
    IS_PCIE        = false,
    IS_ACPI        = false,
    IS_UEFI        = false,
    IS_BIOS        = false,
    IS_EFI         = false,
    IS_SECUREBOOT  = false,
    IS_TPM         = false,
    IS_SELINUX     = false,
    IS_APPARMOR    = false,
    IS_TOMOYO      = false,
    IS_SMACK       = false,
    IS_GRSEC       = false,
    IS_PAX         = false,
    IS_ASLR        = false,
    IS_PIE         = false,
    IS_RELRO       = false,
    IS_CANARY      = false,
    IS_FORTIFY     = false,
    IS_SSP         = false,
    IS_CFI         = false,
    IS_SAFESTACK   = false,
    IS_SHADOWCALL  = false,
    IS_MPX         = false,
    IS_IBT         = false,
    IS_CET         = false,
    IS_SMAP        = false,
    IS_SMEP        = false,
    IS_PKU         = false,
    IS_PKEY        = false,
    IS_UMIP        = false,
    IS_RDRAND      = false,
    IS_RDSEED      = false,
    IS_AES         = false,
    IS_SHA         = false,
    IS_AVX         = false,
    IS_AVX2        = false,
    IS_AVX512      = false,
    IS_FMA         = false,
    IS_BMI         = false,
    IS_ADX         = false,
    IS_RDPMC       = false,
    IS_PMC         = false,
    IS_MSR         = false,
    IS_CPUID       = false,
    IS_XGETBV      = false,
    IS_XSETBV      = false,
    IS_WRMSR       = false,
    IS_RDMSR       = false,
    IS_CPU         = false,
    IS_GPU         = false,
    IS_NPU         = false,
    IS_TPU         = false,
    IS_FPGA        = false,
    IS_ASIC        = false,
}

local function _detect_linux_game_environment()
    local flags = 0
    local linux_indicators = {
        "Linux", "linux", "Ubuntu", "Debian", "Fedora", "CentOS",
        "Arch", "Gentoo", "android", "Android", "termux", "Termux",
        "WSL", "wsl", "docker", "Docker", "container", "Container",
        "lxc", "LXC", "proot", "PRoot", "chroot", "Chroot",
        "Alpine", "alpine", "Red Hat", "SUSE", "openSUSE",
        "Mint", "Manjaro", "Pop!_OS", "elementary", "Zorin",
        "Deepin", "Neon", "KDE", "GNOME", "XFCE", "LXDE",
        "LXQT", "Cinnamon", "MATE", "Budgie", "Pantheon",
        "Unity", "Wayland", "X11", "xorg", "Xorg", "Mesa",
        "mesa", "OpenGL", "Vulkan", "vulkan", "DRI", "drm",
        "i915", "amdgpu", "radeon", "nouveau", "nvidia",
        "NVIDIA", "Intel", "AMD", "Ryzen", "Core", "Xeon",
        "EPYC", "ARM", "arm", "aarch64", "x86_64", "i386", "i686"
    }
    if _A._VERSION then
        local v = _A.tostring(_A._VERSION)
        for _, ind in _A.ipairs(linux_indicators) do
            if v and v:find(ind) then
                flags = flags + 1
                break
            end
        end
    end
    if package and package.config then
        if package.config:find("/") then
            flags = flags + 1
        end
        if package.path and package.path:find("/") and not package.path:find("\\") then
            flags = flags + 1
        end
        if package.cpath and package.cpath:find("/") and not package.cpath:find("\\") then
            flags = flags + 1
        end
    end
    local linux_env_vars = {"LD_LIBRARY_PATH", "LD_PRELOAD", "HOME", "USER", "SHELL", "TERM", "DISPLAY", "XDG_", "WAYLAND_DISPLAY", "DBUS_SESSION_BUS_ADDRESS", "DESKTOP_SESSION", "GDMSESSION", "PULSE_SERVER", "JACK_DEFAULT_SERVER", "PIPEWIRE_RUNTIME_DIR"}
    for _, var in _A.ipairs(linux_env_vars) do
        local env_val = _A.rawget(_G, var) or os.getenv and os.getenv(var)
        if env_val then
            flags = flags + 1
            break
        end
    end
    local ok, err = _A.pcall(function()
        local f = io and io.open and io.open("/proc/self/status", "r")
        if f then
            f:close()
            flags = flags + 2
        end
    end)
    ok, err = _A.pcall(function()
        local f = io and io.open and io.open("/sys/devices", "r")
        if f then
            f:close()
            flags = flags + 1
        end
    end)
    ok, err = _A.pcall(function()
        if os.execute then
            local result = os.execute("uname -a 2>/dev/null")
            if result then
                flags = flags + 2
            end
        end
    end)
    return flags >= 3
end

local function _poison()
    if _DEAD then return end
    _DEAD = true
    local _a, _b = false, 0
    while true do
        _a  = not _a
        _b  = _A.math_fmod(_b + 1, 0xFFFFFFFF)
        _A.math_random(1, 0xFFFF)
        if _A.rawget(_G, "os") and _A.os_exit then
            _A.os_exit(1)
        end
        if _A.rawget(_G, "error") then
            _A.error("Environment integrity compromised", 0)
        end
    end
end

local function _environment_check_advanced()
    if _detect_linux_game_environment() then
        _ENV_FLAGS.IS_LINUX_GAME = true
        _poison()
    end
    _environment_check()
end

_environment_check = _environment_check_advanced

return _environment_check
]]
end

function AntiTamper.generate_anti_tamper_engine()
    return [[
local _E = {
    type             = type,
    rawget           = rawget,
    rawset           = rawset,
    rawequal         = rawequal,
    rawlen           = rawlen,
    pairs            = pairs,
    ipairs           = ipairs,
    next             = next,
    select           = select,
    pcall            = pcall,
    xpcall           = xpcall,
    error            = error,
    assert           = assert,
    tostring         = tostring,
    tonumber         = tonumber,
    setmetatable     = setmetatable,
    getmetatable     = getmetatable,
    string_byte      = string.byte,
    string_char      = string.char,
    string_len       = string.len,
    string_sub       = string.sub,
    string_rep       = string.rep,
    string_format    = string.format,
    string_find      = string.find,
    string_gmatch    = string.gmatch,
    string_gsub      = string.gsub,
    table_concat     = table.concat,
    table_insert     = table.insert,
    table_remove     = table.remove,
    table_sort       = table.sort,
    table_unpack     = table.unpack or unpack,
    math_floor       = math.floor,
    math_ceil        = math.ceil,
    math_abs         = math.abs,
    math_fmod        = math.fmod,
    math_random      = math.random,
    math_randomseed  = math.randomseed,
    math_huge        = math.huge,
    math_max         = math.max,
    math_min         = math.min,
    math_sqrt        = math.sqrt,
    os_clock         = os.clock,
    os_time          = os.time,
    os_exit          = os.exit,
    loadstring       = loadstring,
    loadfile         = loadfile,
    dofile           = dofile,
    debug_getinfo    = debug and debug.getinfo or nil,
    debug_gethook    = debug and debug.gethook or nil,
    debug_getupvalue = debug and debug.getupvalue or nil,
    debug_setupvalue = debug and debug.setupvalue or nil,
    debug_sethook    = debug and debug.sethook or nil,
    debug_getlocal   = debug and debug.getlocal or nil,
    debug_setlocal   = debug and debug.setlocal or nil,
    debug_getuservalue = debug and debug.getuservalue or nil,
    debug_setuservalue = debug and debug.setuservalue or nil,
    debug_upvalueid  = debug and debug.upvalueid or nil,
    debug_upvaluejoin = debug and debug.upvaluejoin or nil,
    coroutine_create = coroutine and coroutine.create or nil,
    coroutine_resume = coroutine and coroutine.resume or nil,
    coroutine_status = coroutine and coroutine.status or nil,
    coroutine_yield  = coroutine and coroutine.yield or nil,
    coroutine_wrap   = coroutine and coroutine.wrap or nil,
    collectgarbage   = collectgarbage,
    gcinfo           = gcinfo,
    _VERSION         = _VERSION,
}

_E.setmetatable(_E, {
    __newindex = function() _E.error("_E is sealed", 0) end,
    __index    = function(_, k) return nil end,
})

local _DEAD        = false
local _WD          = 0
local _LAST_CLOCK  = _E.os_clock()
local _CALL_LOG    = {}
local _RING_SIZE   = 32
local _RING_HEAD   = 0

local _ENV_FLAGS = {
    IS_LUNE   = false,
    IS_FAKE   = false,
    TRACE_LOG = false,
    HOOKED    = false,
    DEBUGGER  = false,
    EMULATED  = false,
    SANDBOXED = false,
}

local function _detect_lune()
    local lune_indicators = {
        "Lune", "lune", "LUNE", "unhandled", "Unhandled"
    }
    for _, ind in _E.ipairs(lune_indicators) do
        if _E.tostring(_E.error) and _E.tostring(_E.error):find(ind) then
            return true
        end
    end
    if _E.tostring(_E._VERSION) and _E.tostring(_E._VERSION):find("Lune") then
        return true
    end
    local lune_globals = {"lune", "_LUNE", "LUNE_ENV"}
    for _, g in _E.ipairs(lune_globals) do
        if _E.rawget(_G, g) ~= nil then
            return true
        end
    end
    return false
end

local function _detect_fake_environment()
    local flags = 0
    local t1 = _E.os_clock()
    local t2 = _E.os_clock()
    if t2 - t1 < 0.0001 then
        flags = flags + 1
    end
    local r1 = _E.math_random(1, 1000)
    local r2 = _E.math_random(1, 1000)
    if r1 == r2 then
        flags = flags + 1
    end
    if _E.type(_E.type) ~= "function" then
        flags = flags + 2
    end
    local ok, _ = _E.pcall(_E.loadstring, "return 1")
    if not ok then
        flags = flags + 1
    end
    if _E.collectgarbage then
        local old = _E.collectgarbage("count")
        _E.collectgarbage("collect")
        local new = _E.collectgarbage("count")
        if old == new then
            flags = flags + 1
        end
    end
    if _E.coroutine_create then
        local co = _E.coroutine_create(function() return 1 end)
        if co and _E.coroutine_resume(co) then
            local ok, val = _E.coroutine_resume(co)
            if ok and val ~= 1 then
                flags = flags + 1
            end
        end
    end
    local test_tbl = {}
    _E.setmetatable(test_tbl, {__index = function() end})
    if _E.getmetatable(test_tbl) == nil then
        flags = flags + 1
    end
    local env = _E.rawget(_G, "_ENV")
    if env and _E.type(env) == "table" and _E.rawget(env, "_G") ~= _G then
        flags = flags + 2
    end
    local function dummy() end
    local info = _E.debug_getinfo and _E.debug_getinfo(dummy, "S")
    if info and info.what == "C" then
        flags = flags + 1
    end
    return flags >= 3
end

local function _detect_trace_log()
    local traces = {
        _E.rawget(_G, "print"),
        _E.rawget(_G, "warn"),
        _E.rawget(_G, "error"),
        _E.rawget(_G, "debug"),
    }
    for _, fn in _E.ipairs(traces) do
        if _E.type(fn) == "function" then
            local s = _E.tostring(fn)
            if s:find("function: %x+") then
                if s:find("hook") or s:find("proxy") or s:find("wrapper") then
                    return true
                end
            end
        end
    end
    if _E.debug_getinfo then
        local info = _E.debug_getinfo(1, "n")
        if info and info.name and (info.name:find("hook") or info.name:find("trace")) then
            return true
        end
    end
    local function recursive(n)
        if n > 10 then return end
        local info = _E.debug_getinfo(n, "S")
        if info and info.source and info.source:find("trace") then
            return true
        end
        return recursive(n+1)
    end
    if recursive(1) then return true end
    return false
end

local function _detect_debugger()
    if _E.debug_getinfo then
        local frames = 0
        for i = 1, 10 do
            local info = _E.debug_getinfo(i, "n")
            if info then frames = frames + 1 else break end
        end
        if frames > 5 then
            return true
        end
    end
    if _E.debug_gethook then
        local hook = _E.debug_gethook()
        if hook ~= nil then
            return true
        end
    end
    local function check_break()
        local ok, err = _E.pcall(function() _E.error("", 0) end)
        if not ok then
            local trace = _E.tostring(err)
            if trace:find("debug") or trace:find("break") then
                return true
            end
        end
        return false
    end
    if check_break() then return true end
    if _E.debug_getlocal then
        local name, val = _E.debug_getlocal(1, 1)
        if name and name:find("debug") then
            return true
        end
    end
    return false
end

local function _detect_proxy_hook()
    local checks = {
        {_E.type, _E.type},
        {_E.rawget, _E.rawget},
        {_E.rawset, _E.rawset},
        {_E.pairs, _E.pairs},
        {_E.ipairs, _E.ipairs},
        {_E.pcall, _E.pcall},
        {_E.xpcall, _E.xpcall},
        {_E.tostring, _E.tostring},
        {_E.tonumber, _E.tonumber},
        {_E.setmetatable, _E.setmetatable},
        {_E.getmetatable, _E.getmetatable},
        {_E.string_byte, _E.string.byte},
        {_E.string_len, _E.string.len},
        {_E.string_sub, _E.string.sub},
        {_E.table_concat, _E.table.concat},
        {_E.table_insert, _E.table.insert},
        {_E.math_floor, _E.math.floor},
        {_E.math_random, _E.math.random},
        {_E.os_clock, _E.os.clock},
        {_E.os_time, _E.os.time},
        {_E.loadstring, _E.loadstring},
    }
    local poisoned = 0
    for _, check in _E.ipairs(checks) do
        local stored, actual = check[1], check[2]
        if not _E.rawequal(stored, actual) then
            poisoned = poisoned + 1
        end
    end
    return poisoned > 3
end

local function _detect_emulated_environment()
    local flags = 0
    if _E.os_time and _E.os_clock then
        local wall0 = _E.os_time()
        local cpu0 = _E.os_clock()
        local wall1, cpu1
        local function burn() for i=1,100000 do local x = i * i end end
        burn()
        wall1 = _E.os_time()
        cpu1 = _E.os_clock()
        local wall_delta = wall1 - wall0
        local cpu_delta = cpu1 - cpu0
        if wall_delta == 0 and cpu_delta > 0.001 then
            flags = flags + 2
        end
        if wall_delta > 1 and cpu_delta < 0.001 then
            flags = flags + 2
        end
        if cpu_delta > 10 then
            flags = flags + 1
        end
    end
    local function test_stack()
        local depth = 0
        local function recurse()
            depth = depth + 1
            if depth < 100 then recurse() end
        end
        local ok = _E.pcall(recurse)
        if ok and depth < 50 then
            flags = flags + 1
        end
    end
    test_stack()
    local co = _E.coroutine_create and _E.coroutine_create(function()
        _E.coroutine_yield()
    end)
    if co then
        local stat = _E.coroutine_status and _E.coroutine_status(co)
        if stat ~= "suspended" then
            flags = flags + 1
        end
    end
    local mt = _E.getmetatable({})
    if mt ~= nil then
        flags = flags + 1
    end
    return flags >= 3
end

local function _detect_sandbox()
    local flags = 0
    local function test_io()
        local ok, err = _E.pcall(function()
            local f = io and io.open and io.open("/etc/passwd", "r")
            if f then f:close() end
        end)
        if ok then
            flags = flags + 1
        end
    end
    test_io()
    local function test_os_exec()
        local ok, err = _E.pcall(function()
            if os.execute then os.execute("echo") end
        end)
        if ok then
            flags = flags + 1
        end
    end
    test_os_exec()
    local function test_load()
        local ok = _E.pcall(_E.loadstring, "return io")
        if ok then
            flags = flags + 1
        end
    end
    test_load()
    local function test_debug_access()
        if _E.debug_getinfo then
            local info = _E.debug_getinfo(1, "S")
            if info and info.source then
                flags = flags + 1
            end
        end
    end
    test_debug_access()
    return flags >= 2
end

local function _environment_check()
    if _detect_lune() then
        _ENV_FLAGS.IS_LUNE = true
        _poison()
    end
    if _detect_fake_environment() then
        _ENV_FLAGS.IS_FAKE = true
        _poison()
    end
    if _detect_trace_log() then
        _ENV_FLAGS.TRACE_LOG = true
        _poison()
    end
    if _detect_debugger() then
        _ENV_FLAGS.DEBUGGER = true
        _poison()
    end
    if _detect_proxy_hook() then
        _ENV_FLAGS.HOOKED = true
        _poison()
    end
    if _detect_emulated_environment() then
        _ENV_FLAGS.EMULATED = true
        _poison()
    end
    if _detect_sandbox() then
        _ENV_FLAGS.SANDBOXED = true
        _poison()
    end
end

local function _fnv1a(s)
    local h = 0x811C9DC5
    for i = 1, _E.string_len(s) do
        h = _E.math_fmod((h ~ _E.string_byte(s, i)) * 0x01000193, 0x100000000)
    end
    return _E.math_floor(h < 0 and h + 0x100000000 or h)
end

local function _djb2(s)
    local h = 5381
    for i = 1, _E.string_len(s) do
        h = _E.math_fmod(h * 33 ~ _E.string_byte(s, i), 0x100000000)
    end
    return _E.math_floor(h < 0 and h + 0x100000000 or h)
end

local function _poison()
    if _DEAD then return end
    _DEAD = true
    local _a, _b = false, 0
    while true do
        _a  = not _a
        _b  = _E.math_fmod(_b + 1, 0xFFFFFFFF)
        _E.math_random(1, 0xFFFF)
    end
end

local _CORRUPT_KEY = _E.tostring(_E.math_random(1, 0xFFFFFFFF))

local function _corrupt(v)
    if _E.type(v) == "number" then return v * 0 / 0 end
    if _E.type(v) == "string" then return _CORRUPT_KEY end
    if _E.type(v) == "boolean" then return not v end
    return nil
end

local _CANARY_FNS = {
    ["type"]          = _E.type,
    ["rawget"]        = _E.rawget,
    ["rawset"]        = _E.rawset,
    ["rawequal"]      = _E.rawequal,
    ["pairs"]         = _E.pairs,
    ["ipairs"]        = _E.ipairs,
    ["pcall"]         = _E.pcall,
    ["xpcall"]        = _E.xpcall,
    ["setmetatable"]  = _E.setmetatable,
    ["getmetatable"]  = _E.getmetatable,
    ["string.byte"]   = _E.string_byte,
    ["string.len"]    = _E.string_len,
    ["string.sub"]    = _E.string_sub,
    ["string.gsub"]   = _E.string_gsub,
    ["math.floor"]    = _E.math_floor,
    ["math.random"]   = _E.math_random,
    ["math.fmod"]     = _E.math_fmod,
    ["table.insert"]  = _E.table_insert,
    ["table.remove"]  = _E.table_remove,
    ["table.concat"]  = _E.table_concat,
    ["os.clock"]      = _E.os_clock,
    ["os.time"]       = _E.os_time,
    ["tonumber"]      = _E.tonumber,
    ["tostring"]      = _E.tostring,
}

local _CANARY_SIG  = {}
local _CANARY_SIG2 = {}

for k, v in _E.pairs(_CANARY_FNS) do
    local s = _E.tostring(v)
    _CANARY_SIG[k]  = _fnv1a(s)
    _CANARY_SIG2[k] = _djb2(s)
end

local function _checkHooks()
    for k, v in _E.pairs(_CANARY_FNS) do
        local s = _E.tostring(v)
        if _fnv1a(s) ~= _CANARY_SIG[k]  then _poison() end
        if _djb2(s)  ~= _CANARY_SIG2[k] then _poison() end
    end

    local _t = {}
    _E.setmetatable(_t, { __index = function() return "HOOKED" end })
    if _E.rawget(_t, "x") ~= nil           then _poison() end
    if not _E.rawequal(_E.rawget,  rawget)  then _poison() end
    if not _E.rawequal(_E.pcall,   pcall)   then _poison() end
    if not _E.rawequal(_E.rawset,  rawset)  then _poison() end
    if not _E.rawequal(_E.type,    type)    then _poison() end
end

local _A1 = _fnv1a(_E.tostring(_fnv1a))
local _A2 = _fnv1a(_E.tostring(_poison))
local _A3 = _fnv1a(_E.tostring(_checkHooks))
local _A4 = _fnv1a(_E.tostring(_djb2))

local _CHUNK_SIG  = _fnv1a(_E.tostring(_A1) .. _E.tostring(_A2) .. _E.tostring(_A3) .. _E.tostring(_A4))
local _CHUNK_SIG2 = _djb2(_E.tostring(_A1)  .. _E.tostring(_A2) .. _E.tostring(_A3) .. _E.tostring(_A4))

local function _checkChunk()
    local a1 = _fnv1a(_E.tostring(_fnv1a))
    local a2 = _fnv1a(_E.tostring(_poison))
    local a3 = _fnv1a(_E.tostring(_checkHooks))
    local a4 = _fnv1a(_E.tostring(_djb2))
    local cur  = _fnv1a(_E.tostring(a1) .. _E.tostring(a2) .. _E.tostring(a3) .. _E.tostring(a4))
    local cur2 = _djb2(_E.tostring(a1)  .. _E.tostring(a2) .. _E.tostring(a3) .. _E.tostring(a4))
    if cur  ~= _CHUNK_SIG  then _poison() end
    if cur2 ~= _CHUNK_SIG2 then _poison() end
end

local function _checkStringMeta()
    local mt = _E.getmetatable("")
    if mt == nil then return end
    local idx = _E.rawget(mt, "__index")
    if not _E.rawequal(idx, string)         then _poison() end
    if _E.rawget(mt, "__newindex") ~= nil   then _poison() end
    if _E.rawget(mt, "__call")     ~= nil   then _poison() end
end

local function _checkTypes()
    local checks = {
        {1,        "number"},
        {"x",      "string"},
        {true,     "boolean"},
        {_fnv1a,   "function"},
        {{},       "table"},
        {nil,      "nil"},
    }
    for _, c in _E.ipairs(checks) do
        if _E.type(c[1]) ~= c[2] then _poison() end
    end
    if _E.type(_E.type) ~= "function" then _poison() end
end

local function _checkPcall()
    local ok1, ok2 = false, false
    local r1 = _E.pcall(function() ok1 = true end)
    if not r1 or not ok1 then _poison() end

    local r2 = _E.pcall(function() _E.error("_AT_", 0) end)
    if r2 then _poison() end

    _E.xpcall(function() ok2 = true end, function() end)
    if not ok2 then _poison() end

    local r3, v3 = _E.pcall(function() return 42 end)
    if not r3 or v3 ~= 42 then _poison() end
end

local _TIMING_BASELINE = nil

local function _timingTrap()
    local t0 = _E.os_clock()
    local s  = 0
    for i = 1, 10000 do
        s = _E.math_fmod(s + i * 3, 0xFFFF)
    end
    local dt = _E.os_clock() - t0

    if dt > 1.2 then _poison() end

    if _TIMING_BASELINE == nil then
        _TIMING_BASELINE = dt
    else
        if dt > _TIMING_BASELINE * 10 + 0.3 then _poison() end
    end

    return s
end

local _REAL_T0    = _E.os_clock()
local _WALL_T0    = _E.os_time()

local function _checkClockDrift()
    local cpu_elapsed  = _E.os_clock() - _REAL_T0
    local wall_elapsed = _E.os_time()  - _WALL_T0
    if cpu_elapsed > 5 and wall_elapsed == 0 then _poison() end
end

local function _checkDebug()
    if not debug then return end

    if debug.setupvalue  then _poison() end
    if debug.upvaluejoin then _poison() end
    if debug.upvalueid   then _poison() end

    if debug.sethook then
        _E.pcall(function()
            local h = debug.gethook and debug.gethook()
            if h ~= nil then _poison() end
        end)
    end

    if debug.getupvalue then
        _E.pcall(function()
            local name = debug.getupvalue(_fnv1a, 1)
            if name ~= nil then _poison() end
        end)
        _E.pcall(function()
            local name = debug.getupvalue(_poison, 1)
            if name ~= nil then _poison() end
        end)
    end

    if debug.getinfo then
        _E.pcall(function()
            local info = debug.getinfo(_poison, "S")
            if info and info.what == "Lua" then _poison() end
        end)
    end
end

local function _checkGlobalProxy()
    local mt = _E.getmetatable(_G)
    if mt then
        if _E.rawget(mt, "__index")    ~= nil then _poison() end
        if _E.rawget(mt, "__newindex") ~= nil then _poison() end
        if _E.rawget(mt, "__pairs")    ~= nil then _poison() end
    end
end

local function _checkErrorLine()
    local function _mkErr()
        local a = _E.math_random(1, 2 ^ 24)
        return a / 0
    end
    local r1 = {_E.pcall(_mkErr)}
    local r2 = {_E.pcall(_mkErr)}
    local l1 = _E.tonumber((_E.tostring(r1[2]) or ""):match(":(%d+):") or "0")
    local l2 = _E.tonumber((_E.tostring(r2[2]) or ""):match(":(%d+):") or "0")
    if l1 ~= l2 then _poison() end
end

local _FREQ_THRESHOLD = 5000
local _FREQ_WINDOW    = {}
local _FREQ_PTR       = 0

local function _checkCallFrequency()
    local now = _E.os_clock()
    _FREQ_PTR = _E.math_fmod(_FREQ_PTR, 64) + 1
    _FREQ_WINDOW[_FREQ_PTR] = now

    local oldest_ptr = _E.math_fmod(_FREQ_PTR, 64) + 1
    local oldest     = _FREQ_WINDOW[oldest_ptr]
    if oldest then
        local span = now - oldest
        if span > 0 and (64 / span) > _FREQ_THRESHOLD then
            _poison()
        end
    end
end

local function _checkExecutionTrace()
    local trace = {}
    for i = 1, 5 do
        local info = _E.debug_getinfo and _E.debug_getinfo(i + 2, "S")
        if info and info.source then
            table.insert(trace, info.source)
        end
    end
    local combined = table.concat(trace)
    if combined:find("hook") or combined:find("debug") then
        _poison()
    end
    local function check_line()
        local ok, err = _E.pcall(function() _E.error("", 0) end)
        if not ok then
            local msg = _E.tostring(err)
            if msg:find(":%d+:%d+") then
                _poison()
            end
        end
    end
    check_line()
end

local _DECOY = _E.setmetatable({}, {
    __index    = function()   _checkHooks(); return nil end,
    __newindex = function()   _poison() end,
    __len      = function()   _checkHooks(); return 0 end,
    __call     = function()   _poison() end,
    __concat   = function()   _poison() end,
    __pairs    = function()   _poison() end,
    __unm      = function()   _poison() end,
    __eq       = function()   _poison() end,
})

local function _logCall()
    _RING_HEAD = _E.math_fmod(_RING_HEAD, _RING_SIZE) + 1
    _CALL_LOG[_RING_HEAD] = _E.os_clock()
end

function AT_CHECK()
    if _DEAD then _poison() end

    _WD = _WD + 1
    _logCall()
    _callFrequency()
    _checkHooks()
    _checkChunk()
    _checkStringMeta()
    _checkTypes()
    _checkPcall()
    _checkGlobalProxy()
    _checkExecutionTrace()
    _environment_check()

    if _WD <= 5 or _WD % 10 == 0 or _E.math_random(1, 20) == 1 then
        _timingTrap()
        _checkDebug()
        _checkErrorLine()
        _checkClockDrift()
    end
end

do
    _environment_check()
    _checkHooks()
    _checkChunk()
    _checkStringMeta()
    _checkTypes()
    _checkPcall()
    _checkGlobalProxy()
    _checkExecutionTrace()
    _timingTrap()
    _checkDebug()
    _checkErrorLine()
    _checkClockDrift()
end
]]
end

function AntiTamper.enhanced_environment_poisoning(src)
    local poison_code = [[
local function _poison_env()
    local _g = _G
    local _orig_print = print
    print = function(...)
        _orig_print("poisoned")
        return _orig_print(...)
    end
    local _orig_os = os
    os.execute = function(...)
        return false
    end
    local _orig_io = io
    io.open = function(...)
        return nil
    end
    local mt = getmetatable(_g) or {}
    mt.__index = function(t, k)
        if k == "os" or k == "io" or k == "print" then
            return nil
        end
        return rawget(t, k)
    end
    setmetatable(_g, mt)
end
_poison_env()
]]
    return poison_code .. src
end

function AntiTamper.advanced_timing_attacks_anti_debug(src)
    local wrapper = string.format([[
local _timing_check = function()
    local t0 = os.clock()
    local s = 0
    for i = 1, 100000 do
        s = s + i * 3
        s = s %% 0xFFFF
    end
    local dt = os.clock() - t0
    if dt < 0.001 then
        error("timing anomaly")
    end
    local function nested()
        local t1 = os.clock()
        for i = 1, 10000 do
            local x = i * i
        end
        local dt2 = os.clock() - t1
        if dt2 < 0.0001 then
            error("nested timing anomaly")
        end
    end
    nested()
end
_timing_check()
]] .. src)
    return wrapper
end

return AntiTamper
