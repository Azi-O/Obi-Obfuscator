Obfuscator - Lua Code Obfuscator

A comprehensive Lua code obfuscator with multiple protection layers and anti-tampering mechanisms.

Overview

This obfuscator transforms Lua source code into a heavily protected version that is extremely difficult to reverse-engineer, debug, or tamper with. It employs multiple layers of obfuscation techniques combined with runtime environment verification.

How It Works

1. String Encryption

Anti-Logging String Encryption

· Applies 12-20 layers of transformations to each string literal
· Uses XOR operations with variable-length keys
· Implements custom Base64 encoding with shuffled alphabets
· Applies Caesar cipher variations with multiple shifts
· Uses polynomial-based encoding
· Strings are decrypted at runtime using self-executing functions

Advanced String Obfuscation

· Multiple encryption methods (XOR, Base64, Caesar, bitwise NOT, reversal)
· Compound encryption with nested transformations
· Runtime decryption using dynamically generated functions
· String splitting into multiple parts with random shuffling

2. Number Obfuscation

Converts numeric literals into complex mathematical expressions:

· Supports operations: addition, subtraction, multiplication, division, modulo, exponentiation
· Bitwise operations (AND, OR, shift)
· Nested expressions up to 8 levels deep
· Each number is transformed into a unique expression that evaluates to the original value

3. Control Flow Obfuscation

Version 5: State Machine Based

· Converts linear code into a state machine
· Each line becomes a state in a dispatch table
· States are shuffled randomly
· Dead code states are added as traps
· State transitions are encoded with XOR and rotation
· Decoded using a decoder loop

Version 6: Coroutine Based

· Each line wrapped in a coroutine
· Coroutines are executed sequentially
· Control flow is hidden within coroutine scheduling

Version 7: Quantum Chaos

· Multiple shuffled permutations of the code
· Random selection of execution order at runtime
· Chaotic control flow with unpredictable branches

Version 8: Adaptive

· Dynamically selects between versions 5, 6, and 7
· Can apply multiple layers of different techniques
· Maximum protection through combined approaches

4. Jump Table Obfuscation

· Converts code blocks into a jump table
· Executes functions based on randomized order
· Hides the actual execution flow
· Functions are called indirectly through table lookups

5. Identifier Renaming

· All variable and function names are replaced with random names
· Generated names are 18-35 characters long
· Names include a hash suffix to prevent collisions
· Preserves Lua keywords and internal variables
· Uses a seen-table to ensure uniqueness

6. Dead Code Injection

Injects non-executing code patterns:

· Self-executing functions with useless operations
· Metatable operations that don't affect execution
· Loop constructs with break conditions
· Recursive functions that always terminate
· Variable assignments that are never used
· 35% chance of AT_CHECK() insertion
· 85% chance of dead code per line

7. Dummy Functions

· Creates 20-40 dummy functions with random names
· Each function contains 5-12 nested functions
· Functions are called immediately but have no effect
· Increases code size and complexity

8. Polymorphic Code Generation

· Generates multiple variants of the code
· Each variant has shuffled line order
· Randomly selects one variant at runtime
· Makes static analysis difficult

9. Dynamic Code Generation

· Encrypts the entire code into byte arrays
· Stores data in reversed XOR-encrypted format
· Decrypts and executes at runtime using loadstring
· Prevents static analysis of the code

10. Metatable Obfuscation

· Wraps code in a metatable-based proxy
· Uses __index, __newindex, __call, __concat metamethods
· Hides the actual function behind a proxy
· Makes decompilation more difficult

11. Anti-Decompilation Techniques

· Creates large tables with metatables
· Wraps functions with argument unpacking
· Prevents traditional decompilation approaches
· Uses self-referential structures

12. Garbage Collection Manipulation

· Disables garbage collection
· Creates large temporary tables
· Forces garbage collection cycles
· Disrupts memory analysis

Protection Mechanisms

Anti-Tamper Engine

Runtime Environment Verification

· Detects Linux game environments (Steam, Proton, Wine)
· Identifies emulation environments
· Checks for API hooking
· Detects proxy tunnels and network manipulation
· Identifies Android, BSD, macOS, Windows environments
· Detects virtual machines and containers
· Identifies debugging tools (GDB, LLDB, Valgrind, etc.)
· Detects cloud environments (AWS, GCP, Azure)
· Checks for GPU presence and X11/Wayland
· Detects architecture (x86, x64, ARM)
· Identifies filesystem types (overlay, AUFS, ZFS, etc.)
· Detects containerization (Docker, LXC, Kubernetes)
· Identifies chroot and jail environments
· Detects secure boot and UEFI
· Identifies SELinux and AppArmor
· Detects hypervisors (VMware, VirtualBox, KVM, QEMU, Xen)

Integrity Checking

· Function signature verification using FNV-1a and DJB2 hashes
· Checksum verification of critical functions
· Metatable integrity checks
· Type verification
· pcall/xpcall integrity verification
· String metatable verification
· Global proxy detection
· Error line consistency checks
· Call frequency monitoring
· Execution tracing detection

Anti-Debugging

· Timing-based trap detection
· Debug hook detection
· Debug info detection
· Breakpoint detection
· Stack frame analysis
· Clock drift detection
· Speed throttling detection

Runtime Protection

· Poison function triggers on detection
· Environment corruption
· Infinite loops on compromise
· Exit on critical violations
· Self-destruct mechanisms

Usage

```lua
local obi = require("obfuscator")

local obfuscated = obi.obfuscate(source_code, {
    antilogging = true,      -- Anti-logging string encryption
    strtable = true,         -- Advanced string encryption
    numbers = true,          -- Number obfuscation
    dummyfuncs = true,       -- Dummy function injection
    deadcode = true,         -- Dead code injection
    flatten = true,          -- Control flow flattening
    layers = 3,              -- Number of control flow layers
    rename = true,           -- Identifier renaming
    antitamper = true,       -- Anti-tamper engine
    stringsplit = true,      -- String splitting
    dynamiccode = true,      -- Dynamic code generation
    timingattack = true,     -- Timing attack protection
    polymorphic = true,      -- Polymorphic code
    envpoison = true,        -- Environment poisoning
    jumptables = true,       -- Jump table obfuscation
    metatable = true,        -- Metatable obfuscation
    antidecomp = true,       -- Anti-decompilation
    gcmanip = true,          -- GC manipulation
    selfexec = true,         -- Self-executing wrapper
    fullencrypt = false      -- Full script encryption
})
```

Achitzin:
Current Obfuscation Techniques:
```
Control Flow Flattening
Jump Table
Coroutine-based execution
Multi-layer flattening
Random state ordering
Dead state injection
State encoding with bitwise rotation/XOR
Trap sequence generation
String encryption (XOR)
String encryption (Caesar)
String encryption (Base64)
String encryption (bitwise NOT)
String encryption (reverse)
String encryption (polynomial)
Multi-layer string encryption
Number obfuscation (arithmetic)
Number obfuscation (bitwise)
Number obfuscation (nested expressions)
Dynamic key generation
String splitting
String shuffling
Full script encryption
Identifier renaming
Reserved keyword protection
Random suffix hashing
Environment detection (Linux)
Environment detection (Windows)
Environment detection (macOS)
Environment detection (BSD)
Environment detection (Android)
Environment detection (Termux)
VM detection (VMware)
VM detection (VirtualBox)
VM detection (QEMU)
VM detection (KVM)
VM detection (Xen)
VM detection (Hyper-V)
Container detection (Docker)
Container detection (LXC/LXD)
Container detection (Podman)
Container detection (Kubernetes)
Debugger detection
Profiler detection (Valgrind)
Profiler detection (GDB/LLDB)
Profiler detection (strace/ltrace)
Profiler detection (perf)
API hooking detection
Log redirection detection
Code regeneration detection
Proxy/tunnel detection
Fake environment detection
Timing attack
Nested timing trap
Function hashing (FNV-1a)
Function hashing (DJB2)
Periodic integrity check
Chunk signature check
String metatable lock
Global proxy detection
Error line consistency check
Call frequency trap
Execution trace detection
Metatable decoy
Poison mechanism
Dead code injection
Dummy function injection
Inline garbage
AT_CHECK injection
Random expression injection
Polymorphic code generation
Dynamic code generation
Metatable proxy
Anti-decompilation
Garbage collection manipulation
Environment poisoning
```
