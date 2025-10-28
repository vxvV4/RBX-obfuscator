--[[
    Version: 2.0.0
    Last Update: 29 / 10 / 2025 | Day / Month / Year
    Modernized obfuscator with improved name generation
]]--

-- Utility Functions
local function chararray(str)
    local chars = {}
    for i = 1, #str do
        chars[i] = str:sub(i, i)
    end
    return chars
end

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

-- Name Generator Configuration
local MIN_CHARACTERS = 5
local MAX_INITIAL_CHARACTERS = 10

local offset = 0
local VarDigits = chararray("Il1")
local VarStartDigits = chararray("Il")

local function generateName(id)
    local name = ''
    id = id + offset
    local d = id % #VarStartDigits
    id = (id - d) / #VarStartDigits
    name = name .. VarStartDigits[d + 1]
    while id > 0 do
        d = id % #VarDigits
        id = (id - d) / #VarDigits
        name = name .. VarDigits[d + 1]
    end
    return name
end

local function prepareNameGenerator()
    shuffle(VarDigits)
    shuffle(VarStartDigits)
    offset = math.random(3 ^ MIN_CHARACTERS, 3 ^ MAX_INITIAL_CHARACTERS)
end

-- String to Binary Conversion
local function StringToBinary(String)
    local BinaryString = {}
    for i, Character in ipairs(String:split('')) do
        local Binary = ""
        local Byte = Character:byte()
        while Byte > 0 do
            Binary = tostring(Byte % 2) .. Binary
            Byte = math.modf(Byte / 2)
        end
        table.insert(BinaryString, string.format("%.8d", Binary))
    end
    return table.concat(BinaryString, " ")
end

-- Add Binary Junk Variables
local function addBinaryJunk(number, varPrefix, s)
    local topics = {
        "Deobfuscate?",
        "Hello World!",
        "Touch some grass",
        "New update when?",
        "Free obfuscator!",
        "Modernized v2.0",
    }
    
    for i = 1, tonumber(number) do
        local varName = generateName(math.random(1000, 9999))
        local topic = topics[math.random(1, #topics)]
        local str = "local " .. varPrefix .. varName .. ' = "' .. StringToBinary(topic) .. '"; '
        s = s .. str
    end
    
    return tostring(s)
end

-- Main Obfuscation Function
function obfuscate(source, VarName, WaterMark)
    warn("Started obfuscation...")
    
    local Variable = VarName or "Taurus_"
    local WM
    
    if source == nil then
        source = [[print("Hello World!")]]
    end
    
    local ticks = tick()
    
    -- Prepare name generator
    prepareNameGenerator()
    
    -- Watermark
    if typeof(WaterMark) == "string" and WaterMark ~= nil then
        WM = "    " .. tostring(WaterMark) .. " | Modernized Obfuscator v2.0"
    else
        WM = "    WaterMark | Modernized Obfuscator v2.0"
    end
    WM = "--[[\n" .. tostring(WM) .. "\n]]--\n\n"
    
    -- Generate unique variable names
    local varTableByte = Variable .. generateName(1)
    local varLoadstring = Variable .. generateName(2)
    local varTroll = Variable .. generateName(3)
    
    -- Convert source to byte array
    local SourceByte = ""
    for i = 1, string.len(source) do
        SourceByte = SourceByte .. '"\\'.. string.byte(source, i) .. '", '
    end
    
    -- Create troll function with junk
    local trollFunc = "function() " .. addBinaryJunk(math.random(20, 35), Variable, "") .. " end"
    local trollVar = "local " .. varTroll .. " = " .. trollFunc
    
    -- Table with byte array
    local TableByte = "local " .. varTableByte .. " = {" .. SourceByte .. "}"
    
    -- Loadstring loader
    local Loadstring = 'local ' .. varLoadstring .. ' = loadstring(table.concat({"\\114", "\\101", "\\116", "\\117", "\\114", "\\110", "\\32", "\\102", "\\117", "\\110", "\\99", "\\116", "\\105", "\\111", "\\110", "\\40", "\\98", "\\121", "\\116", "\\101", "\\41", "\\10", "\\32", "\\32", "\\32", "\\32", "\\105", "\\102", "\\32", "\\116", "\\121", "\\112", "\\101", "\\111", "\\102", "\\40", "\\98", "\\121", "\\116", "\\101", "\\41", "\\32", "\\61", "\\61", "\\32", "\\34", "\\116", "\\97", "\\98", "\\108", "\\101", "\\34", "\\32", "\\116", "\\104", "\\101", "\\110", "\\10", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\108", "\\111", "\\97", "\\100", "\\115", "\\116", "\\114", "\\105", "\\110", "\\103", "\\40", "\\116", "\\97", "\\98", "\\108", "\\101", "\\46", "\\99", "\\111", "\\110", "\\99", "\\97", "\\116", "\\40", "\\98", "\\121", "\\116", "\\101", "\\41", "\\41", "\\40", "\\41", "\\10", "\\32", "\\32", "\\32", "\\32", "\\101", "\\108", "\\115", "\\101", "\\10", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\98", "\\121", "\\116", "\\101", "\\32", "\\61", "\\32", "\\123", "\\98", "\\121", "\\116", "\\101", "\\125", "\\10", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\32", "\\108", "\\111", "\\97", "\\100", "\\115", "\\116", "\\114", "\\105", "\\110", "\\103", "\\40", "\\116", "\\97", "\\98", "\\108", "\\101", "\\46", "\\99", "\\111", "\\110", "\\99", "\\97", "\\116", "\\40", "\\98", "\\121", "\\116", "\\101", "\\41", "\\41", "\\40", "\\41", "\\10", "\\32", "\\32", "\\32", "\\32", "\\101", "\\110", "\\100", "\\10", "\\101", "\\110", "\\100", "\\10",}))()'
    
    -- Generate fake code blocks
    local function generateFakeCode(count)
        local fakes = {}
        for i = 1, count do
            local fakeVar = Variable .. generateName(math.random(5000, 9999))
            local fakeContent = "return " .. generateName(math.random(10000, 99999))
            local byte = ""
            for x = 1, string.len(fakeContent) do
                byte = byte .. '"\\'.. string.byte(fakeContent, x) .. '", '
            end
            local fake = "local " .. fakeVar .. " = {" .. byte .. "}; local " .. fakeVar .. " = " .. varLoadstring .. "(" .. fakeVar .. "); "
            table.insert(fakes, fake)
        end
        return table.concat(fakes, "")
    end
    
    -- Final execution variable
    local finalVar = Variable .. generateName(9999)
    
    -- Build obfuscated code with wrapper
    local obfuscated = WM .. 
        "return (function(...)\n" ..
        trollVar .. "; " ..
        Loadstring .. "; " ..
        generateFakeCode(math.random(2, 4)) ..
        TableByte .. "; " ..
        "local " .. finalVar .. " = " .. varLoadstring .. "(" .. varTableByte .. "); " ..
        generateFakeCode(math.random(2, 3)) ..
        "\nend)(...)"
    
    setclipboard(obfuscated)
    warn("Done! Obfuscated in " .. tostring(tick() - ticks) .. " seconds")
    
    return obfuscated
end

-- Module Export
return function(source, CustomVarName, WaterMark)
    task.spawn(function()
        obfuscate(source, CustomVarName, WaterMark)
    end)
end
