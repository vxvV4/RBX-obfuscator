--[[
    Version: 2.0.0
    Last Update: 29 / 10 / 2025 | Day / Month / Year
    Advanced obfuscator with XOR encryption and mangled names
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

-- Mangled Name Generator Configuration
local VarDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
local VarStartDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

local function generateName(id)
    local name = ''
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
end

-- XOR Encryption
local function xorEncrypt(str, key)
    local encrypted = {}
    local keyLen = #key
    for i = 1, #str do
        local charCode = string.byte(str, i)
        local keyChar = string.byte(key, ((i - 1) % keyLen) + 1)
        table.insert(encrypted, charCode ~ keyChar)
    end
    return encrypted
end

-- Generate random XOR key
local function generateXORKey(length)
    local key = ""
    for i = 1, length do
        key = key .. string.char(math.random(33, 126))
    end
    return key
end

-- Main Obfuscation Function
function obfuscate(source, VarName, WaterMark)
    warn("Started obfuscation...")
    
    local Variable = VarName or ""
    local WM
    
    if source == nil then
        source = [[print("Hello World!")]]
    end
    
    local ticks = tick()
    
    -- Prepare name generator
    prepareNameGenerator()
    
    -- Generate XOR key
    local xorKey = generateXORKey(math.random(16, 32))
    local encryptedBytes = xorEncrypt(source, xorKey)
    
    -- Watermark (compact)
    if typeof(WaterMark) == "string" and WaterMark ~= nil then
        WM = "--[[ " .. tostring(WaterMark) .. " ]]--"
    else
        WM = "--[[ Protected ]]--"
    end
    
    -- Generate unique variable names with mangled characters
    local varKey = Variable .. generateName(math.random(100, 999))
    local varData = Variable .. generateName(math.random(1000, 9999))
    local varDecrypt = Variable .. generateName(math.random(10000, 99999))
    local varLoader = Variable .. generateName(math.random(100000, 999999))
    local varResult = Variable .. generateName(math.random(1000000, 9999999))
    
    -- Build XOR key array (compact)
    local keyArray = "{"
    for i = 1, #xorKey do
        keyArray = keyArray .. string.byte(xorKey, i)
        if i < #xorKey then keyArray = keyArray .. "," end
    end
    keyArray = keyArray .. "}"
    
    -- Build encrypted data array (compact)
    local dataArray = "{"
    for i, byte in ipairs(encryptedBytes) do
        dataArray = dataArray .. byte
        if i < #encryptedBytes then dataArray = dataArray .. "," end
    end
    dataArray = dataArray .. "}"
    
    -- XOR Decryption function (compact, no newlines)
    local decryptFunc = "function(" .. varData .. "," .. varKey .. ") local " .. varResult .. "='' local " .. generateName(math.random(50, 99)) .. "=#" .. varKey .. " for " .. generateName(math.random(10, 49)) .. "=1,#" .. varData .. " do local " .. generateName(math.random(5, 9)) .. "=" .. varData .. "[" .. generateName(math.random(10, 49)) .. "]local " .. generateName(math.random(3, 4)) .. "=" .. varKey .. "[((" .. generateName(math.random(10, 49)) .. "-1)%" .. generateName(math.random(50, 99)) .. ")+1]" .. varResult .. "=" .. varResult .. "..string.char(" .. generateName(math.random(5, 9)) .. "~" .. generateName(math.random(3, 4)) .. ")end return " .. varResult .. " end"
    
    -- Proper XOR decrypt function builder
    local realDecryptFunc = "function(" .. varData .. "," .. varKey .. ")local " .. varResult .. "=''for i=1,#" .. varData .. " do " .. varResult .. "=" .. varResult .. "..string.char(" .. varData .. "[i]~" .. varKey .. "[((i-1)%#" .. varKey .. ")+1])end return " .. varResult .. " end"
    
    -- Build obfuscated code (single line, very compact)
    local obfuscated = WM .. 
        "return(function()local " .. varKey .. "=" .. keyArray .. " local " .. varData .. "=" .. dataArray .. " local " .. varDecrypt .. "=" .. realDecryptFunc .. " local " .. varLoader .. "=" .. varDecrypt .. "(" .. varData .. "," .. varKey .. ")return loadstring(" .. varLoader .. ")()end)()"
    
    -- Make it even longer by adding encoded layers
    local finalVarKey = Variable .. generateName(math.random(50000, 99999))
    local finalVarData = Variable .. generateName(math.random(100000, 999999))
    local finalVarFunc = Variable .. generateName(math.random(200000, 999999))
    
    -- Double XOR encryption for extra security
    local secondKey = generateXORKey(math.random(20, 40))
    local secondEncrypted = xorEncrypt(obfuscated, secondKey)
    
    local secondKeyArray = "{"
    for i = 1, #secondKey do
        secondKeyArray = secondKeyArray .. string.byte(secondKey, i)
        if i < #secondKey then secondKeyArray = secondKeyArray .. "," end
    end
    secondKeyArray = secondKeyArray .. "}"
    
    local secondDataArray = "{"
    for i, byte in ipairs(secondEncrypted) do
        secondDataArray = secondDataArray .. byte
        if i < #secondEncrypted then secondDataArray = secondDataArray .. "," end
    end
    secondDataArray = secondDataArray .. "}"
    
    -- Final wrapper with double XOR (super compact, no newlines)
    local finalObfuscated = WM .. 
        "return(function()local " .. finalVarKey .. "=" .. secondKeyArray .. " local " .. finalVarData .. "=" .. secondDataArray .. " local " .. finalVarFunc .. "=function(d,k)local r=''for i=1,#d do r=r..string.char(d[i]~k[((i-1)%#k)+1])end return r end return loadstring(" .. finalVarFunc .. "(" .. finalVarData .. "," .. finalVarKey .. "))()end)()"
    
    setclipboard(finalObfuscated)
    warn("Done! Obfuscated in " .. tostring(tick() - ticks) .. " seconds")
    warn("Output length: " .. #finalObfuscated .. " characters")
    
    return finalObfuscated
end

-- Module Export
return function(source, CustomVarName, WaterMark)
    return obfuscate(source, CustomVarName, WaterMark)
end
