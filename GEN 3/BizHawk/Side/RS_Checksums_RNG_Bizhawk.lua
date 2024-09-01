read32bit = memory.read_u32_le
read16bit = memory.read_u16_le
read8bit = memory.readbyte
bxor = bit.bxor

local savePath = "C:\\Users\\username\\Desktop\\BizHawk\\GBA\\SaveRAM\\Pokemon Ruby.SaveRAM"
local targetSeed = 0xCF37
local targetHour = 0
local targetMinute = 15
local targetSecond = 45
local targetSixtiethSecond = 30
local delaySecond = 0
local delaySixtiethSecond = 38

local gameVersion = read8bit(0x080000AE)
local game
local gameLang = read8bit(0x080000AF)
local language = ""
local warning
local emuWindow = {}

if gameVersion == 0x56 then -- Check game version
    game = "Ruby"
elseif gameVersion == 0x50 then
    game = "Sapphire"
elseif gameVersion == 0x52 then
    game = "FireRed"
elseif gameVersion == 0x47 then
    game = "LeafGreen"
elseif gameVersion == 0x45 then
    game = "Emerald"
end

if gameLang == 0x4A then -- Check game language
    language = "JPN"
elseif gameLang == 0x45 then
    language = "USA"
else
    language = "EUR"
end

if game ~= "Ruby" and game ~= "Sapphire" then
    warning = " - Wrong game version! Use Ruby/Sapphire instead"
else
    warning = ""
end

console.clear()
print("Devon Studios x Real.96")
print("Adapted for BizHawk by LegoFigure11 for Wi-Fi Labs")
print("")
print("Game Version: " .. game .. warning)
print("Language: " .. language)

local time = 0x02F64EB3
local mode = { "Jirachi", "10th Anniv/Aura Mew" }
local index = 1
local prevKey = {}
local leftArrowColor
local rightArrowColor

local baseHour = targetHour
local baseMinute = targetMinute
local baseSecond = targetSecond
local baseSixtiethSecond = targetSixtiethSecond

baseSixtiethSecond = baseSixtiethSecond - delaySixtiethSecond

if baseSixtiethSecond < 0 then
    baseSixtiethSecond = 60 + baseSixtiethSecond
    baseSecond = baseSecond - 1

    if baseSecond < 0 then
        baseSecond = 60 + baseSecond
        baseMinute = baseMinute - 1

        if baseMinute < 0 then
            baseMinute = 60 + baseMinute
            baseHour = baseHour - 1
        end
    end
end

baseSecond = baseSecond - delaySecond

if baseSecond < 0 then
    baseSecond = 60 + baseSecond
    baseSecond = baseSecond - 1

    if baseSecond < 0 then
        baseSecond = 60 + baseSecond
        baseMinute = baseMinute - 1

        if baseMinute < 0 then
            baseMinute = 60 + baseMinute
            baseHour = baseHour - 1
        end
    end
end

function getScreenDimensions()
    emuWindow.height = client.screenheight()
    emuWindow.width = client.screenwidth()
    emuWindow.topPadding = client.borderheight()
    emuWindow.leftPadding = client.borderwidth()
    emuWindow.bottomPadding = emuWindow.height - emuWindow.topPadding - 18
    emuWindow.rightPadding = emuWindow.width - emuWindow.leftPadding - 18
end

function getInput()
    leftArrowColor = "gray"
    rightArrowColor = "gray"

    local key = input.get()

    if (key["Number1"] or key["Keypad1"]) and (not prevKey["Number1"] and not prevKey["Keypad1"]) then
        leftArrowColor = "orange"
        index = index - 1

        if index < 1 then
            index = table.getn(mode)
        end
    elseif (key["Number2"] or key["Keypad2"]) and (not prevKey["Number2"] and not prevKey["Keypad2"]) then
        rightArrowColor = "orange"
        index = index + 1

        if index > table.getn(mode) then
            index = 1
        end
    end

    prevKey = key
end

function drawArrowLeft(a, b, c)
    gui.drawLine(a, b + 3, a + 2, b + 5, c)
    gui.drawLine(a, b + 3, a + 2, b + 1, c)
    gui.drawLine(a, b + 3, a + 6, b + 3, c)
end

function drawArrowRight(a, b, c)
    gui.drawLine(a, b + 3, a - 2, b + 5, c)
    gui.drawLine(a, b + 3, a - 2, b + 1, c)
    gui.drawLine(a, b + 3, a - 6, b + 3, c)
end

function isSeedGenerated()
    return read32bit(0x0E000FF8) ~= 0
end

function getFirstSegmentSeed()
    local startingCheckBlocksAddr = 0x0E000FF4
    local checkSumSegment = read8bit(startingCheckBlocksAddr)

    return read16bit(startingCheckBlocksAddr + ((14 - checkSumSegment) * 0x1000) + 0x2)
end

function getAllChecksums()
    local saveFile = assert(io.open(savePath, "rb"))
    local bytes = saveFile:read(0x20000)
    saveFile:close()
    local saveBlockStart = 0xFF7
    local saveBlockChecksums = {}

    for i = 0, 0x1F000, 0x1000 do
        checkSumAddr = saveBlockStart + i
        checkSum = string.format("%02X%02X", bytes:byte(checkSumAddr + 1), bytes:byte(checkSumAddr))
        checkSum = tonumber(checkSum, 16)
        table.insert(saveBlockChecksums, checkSum)
    end

    return saveBlockChecksums
end

function calcXorSeed(checkSums)
    local xorSeed = 0

    for i = 1, getTableSize(checkSums) do
        xorSeed = bxor(xorSeed, checkSums[i])
    end

    return xorSeed
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

while warning == "" do
    getScreenDimensions()
    getInput()
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding, "Mode: " .. mode[index])
    drawArrowLeft(102, 0, leftArrowColor)
    gui.text((emuWindow.width / 2) - 21, emuWindow.topPadding, "1 - 2")
    drawArrowRight(140, 0, rightArrowColor)

    hour = string.format("%02d", read16bit(0x02024EB2))
    minute = string.format("%02d", read8bit(time + 0x01))
    second = string.format("%02d", read8bit(time + 0x02))
    sixtiethSecond = string.format("%02d", read8bit(time + 0x03))

    currSeed = read32bit(0x03004818)

    tid = read16bit(0x2024EAE)
    sid = read16bit(0x2024EB0)

    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 18,
        string.format("Time: %02d:%02d:%02d:%02d", hour, minute, second, sixtiethSecond))
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 36, "Visual Frame: " .. emu.framecount() - 5)
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 54, string.format("Current Seed: %04X", currSeed))
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 72, string.format("Target Seed: %04X", targetSeed))
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 90,
        string.format("Target Time: %02d:%02d:%02d:%02d", targetHour, targetMinute, targetSecond, targetSixtiethSecond))
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 108,
        string.format("Delay: %02d:%02d", delaySecond, delaySixtiethSecond))
    gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 126,
        string.format("Base Save Time: %02d:%02d:%02d:%02d", baseHour, baseMinute, baseSecond, baseSixtiethSecond))

    if isSeedGenerated() then
        firstSegmentSeed = getFirstSegmentSeed()

        if mode[index] == "10th Anniv/Aura Mew" then
            checkSums = getAllChecksums()

            actualSeed = calcXorSeed(checkSums)
            xorTargetSeed = bxor(bxor(actualSeed, firstSegmentSeed), targetSeed)

            gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 144,
                string.format("Checksum Seed: %04X", firstSegmentSeed))
            gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 162,
                string.format("Actual XOR Seed: %04X", actualSeed))
            gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 180,
                string.format("Target Checksum Seed: %04X", xorTargetSeed))
        else
            gui.text(emuWindow.leftPadding + 1, emuWindow.topPadding + 144,
                string.format("Jirachi Seed: %04X", firstSegmentSeed))
        end
    end

    gui.text(emuWindow.rightPadding - 85, emuWindow.bottomPadding - 18, "TID: " .. tid)
    gui.text(emuWindow.rightPadding - 85, emuWindow.bottomPadding, "SID: " .. sid)

    emu.frameadvance()
end
