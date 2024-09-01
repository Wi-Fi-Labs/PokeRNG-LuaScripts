-- Pokemon gen 4 lua script by MKDasher
-- Japanese Diamond/Pearl support and auto-detection added by Fortranm
-----------
	-- Press 3 - 4 to change mode (Party / Enemy / Enemy 2 / Partner / Wild)
	-- Press 7 - 8 to change number slot.
	-- Press 9 to change view.
-----------

local ext = require "gen4_and_5_pokemon_extension"
local json = require('json')
local indentjson = true
local ticklength = 1 -- seconds
local memory, gui, input = _G.memory, _G.gui, _G.input

local band, bxor = bit.band, bit.bxor
local rshift, lshift = bit.rshift, bit.lshift

local xfix = 10
local yfix = 10
local function drawbox(a, b, c, d, e, f)
	gui.box(a + xfix, b + yfix, c + xfix, d + yfix, e, f)
end

local function drawtext(a, b, c, d)
	gui.text(xfix + a, yfix + b, c,  d)
end

local function drawarrowleft(a, b, c)
	gui.line(a + xfix, b + yfix + 3, a + 2 + xfix, b + 5 + yfix, c)
	gui.line(a + xfix, b + yfix + 3, a + 2 + xfix, b + 1 + yfix, c)
	gui.line(a + xfix, b + yfix + 3, a + 6 + xfix, b + 3 + yfix, c)
end

local function drawarrowright(a, b, c)
	gui.line(a + xfix, b + yfix + 3, a - 2 + xfix, b + 5 + yfix, c)
	gui.line(a + xfix, b + yfix + 3, a - 2 + xfix, b + 1 + yfix, c)
	gui.line(a + xfix, b + yfix + 3, a - 6 + xfix, b + 3 + yfix, c)
end

local function mult32(a, b)
	local c=rshift(a, 16)
	local d=a%0x10000
	local e=rshift(b, 16)
	local f=b%0x10000
	local g=(c*f+d*e)%0x10000
	local h=d*f
	local i=g*0x10000+h
	return i
end

local function getbits(a, b, d)
	return rshift(a, b) % lshift(1, d)
end

local function gettop(a)
	return (rshift(a, 16))
end

local function getGame()
	local gameIDAddr = memory.readdword(0x23FFE0C)
	if gameIDAddr == 0x45415041 or gameIDAddr == 0x45414441 then --D/P(U)
		return 1
	elseif gameIDAddr == 0x4A415041 or gameIDAddr == 0x4A414441 then --D/P(J)
		return 8
	elseif gameIDAddr == 0x45555043 then --Platinum
		return 3
	elseif gameIDAddr == 0x454B5049 or gameIDAddr == 0x45475049 then --HG/SS
		return 2
	elseif gameIDAddr == 0x4F425249 then --Black
		return 4
	elseif gameIDAddr == 0x4F415249 then --White
		return 5
	elseif gameIDAddr == 0x4F455249 then --Black 2
		return 6
	elseif gameIDAddr == 0x4F445249 then --White 2
		return 7
	else
		return -1
	end
end

local function getGen(game)
	if game < 4 or game == 8 then
		return 4
	else
		return 5
	end
end

local function getGameName(game)
	if game == 1 then
		return "D/P(U)"
	elseif game == 2 then
		return "HG/SS"
	elseif game == 3 then
		return "Platinum"
	elseif game == 4 then
		return "Black"
	elseif game == 5 then
		return "White"
	elseif game == 6 then
		return "Black 2"
	elseif game == 7 then
		return "White 2"
	elseif game == 8 then
		return "D/P(J)"
	else
		return "Invalid"
	end
end

local function getPointer(game)
	if game == 1 then
		return memory.readdword(0x02106FAC)
	elseif game == 2 then
		return memory.readdword(0x0211186C)
	elseif game == 3 then
		return memory.readdword(0x02101D2C)
	else -- game == 8
		return memory.readdword(0x02108804)
	end
	-- haven't found pointers for BW/B2W2, probably not needed anyway.
end

local function getCurFoeHP(game, pointer, mode)
	if game == 1 or game == 8 then -- Pearl
		if mode == 4 then -- Partner's hp
			return memory.readword(pointer + 0x5574C)
		elseif mode == 3 then -- Enemy 2
			return memory.readword(pointer + 0x5580C)
		else
			return memory.readword(pointer + 0x5568C)
		end
	elseif game == 2 then --Heartgold
		if mode == 4 then -- Partner's hp
			return memory.readword(pointer + 0x56FC0)
		elseif mode == 3 then -- Enemy 2
			return memory.readword(pointer + 0x57080)
		else
			return memory.readword(pointer + 0x56F00)
		end
	else--if game == 3 then --Platinum
		if mode == 4 then -- Partner's hp
			return memory.readword(pointer + 0x54764)
		elseif mode == 3 then -- Enemy 2
			return memory.readword(pointer + 0x54824)
		else
			return memory.readword(pointer + 0x546A4)
		end
	end
end

local function getPidAddr(game, pointer, mode, submode)
	if game == 1 or game == 8 then --Pearl
		local enemyAddr = pointer + 0x364C8
		if mode == 5 then
			return pointer + 0x36C6C
		elseif mode == 4 then
			return memory.readdword(enemyAddr) + 0x774 + 0x5B0 + 0xEC*(submode-1)
		elseif mode == 3 then
			return memory.readdword(enemyAddr) + 0x774 + 0xB60 + 0xEC*(submode-1)
		elseif mode == 2 then
			return memory.readdword(enemyAddr) + 0x774 + 0xEC*(submode-1)
		else
			return pointer + 0xD2AC + 0xEC*(submode-1)
		end
	elseif game == 2 then --HeartGold
		local enemyAddr = pointer + 0x37970
		if mode == 5 then
			return pointer + 0x38540
		elseif mode == 4 then
			return memory.readdword(enemyAddr) + 0x1C70 + 0xA1C + 0xEC*(submode-1)
		elseif mode == 3 then
			return memory.readdword(enemyAddr) + 0x1C70 + 0x1438 + 0xEC*(submode-1)
		elseif mode == 2 then
			return memory.readdword(enemyAddr) + 0x1C70 + 0xEC*(submode-1)
		else
			return pointer + 0xD088 + 0xEC*(submode-1)
		end
	elseif game == 3 then --Platinum
		local enemyAddr = pointer + 0x352F4
		if mode == 5 then
			return pointer + 0x35AC4
		elseif mode == 4 then
			return memory.readdword(enemyAddr) + 0x7A0 + 0x5B0 + 0xEC*(submode-1)
		elseif mode == 3 then
			return memory.readdword(enemyAddr) + 0x7A0 + 0xB60 + 0xEC*(submode-1)
		elseif mode == 2 then
			return memory.readdword(enemyAddr) + 0x7A0 + 0xEC*(submode-1)
		else
			return pointer + 0xD094 + 0xEC*(submode-1)
		end
	elseif game == 4 then --Black
		if mode == 5 then
			return 0x02259DD8
		elseif mode == 4 then
			return 0x0226B7B4 + 0xDC*(submode-1)
		elseif mode == 3 then
			return 0x0226C274 + 0xDC*(submode-1)
		elseif mode == 2 then
			return 0x0226ACF4 + 0xDC*(submode-1)
		else -- mode 1
			return 0x022349B4 + 0xDC*(submode-1)
		end
	elseif game == 5 then --White
		if mode == 5 then
			return 0x02259DF8
		elseif mode == 4 then
			return 0x0226B7D4 + 0xDC*(submode-1)
		elseif mode == 3 then
			return 0x0226C294 + 0xDC*(submode-1)
		elseif mode == 2 then
			return 0x0226AD14 + 0xDC*(submode-1)
		else -- mode 1
			return 0x022349D4 + 0xDC*(submode-1)
		end
	elseif game == 6 then --Black 2
		if mode == 5 then
			return 0x0224795C
		elseif mode == 4 then
			return 0x022592F4 + 0xDC*(submode-1)
		elseif mode == 3 then
			return 0x02259DB4 + 0xDC*(submode-1)
		elseif mode == 2 then
			return 0x02258834 + 0xDC*(submode-1)
		else -- mode 1
			return 0x0221E3EC + 0xDC*(submode-1)
		end
	else --White 2
		if mode == 5 then
			return 0x0224799C
		elseif mode == 4 then
			return 0x02259334 + 0xDC*(submode-1)
		elseif mode == 3 then
			return 0x02259DF4 + 0xDC*(submode-1)
		elseif mode == 2 then
			return 0x02258874 + 0xDC*(submode-1)
		else -- mode 1
			return 0x0221E42C + 0xDC*(submode-1)
		end
	end
end

local function getNatClr(a, nat)
	local color = "yellow"
	if nat % 6 == 0 then
		color = "yellow"
	elseif a == "atk" then
		if nat < 5 then
			color = "red"
		elseif nat % 5 == 0 then
			color = "#0080FFFF"
		end
	elseif a == "def" then
		if nat > 4 and nat < 10 then
			color = "red"
		elseif nat % 5 == 1 then
			color = "#0080FFFF"
		end
	elseif a == "spe" then
		if nat > 9 and nat < 15 then
			color = "red"
		elseif nat % 5 == 2 then
			color = "#0080FFFF"
		end
	elseif a == "spa" then
		if nat > 14 and nat < 20 then
			color = "red"
		elseif nat % 5 == 3 then
			color = "#0080FFFF"
		end
	elseif a == "spd" then
		if nat > 19 then
			color = "red"
		elseif nat % 5 == 4 then
			color = "#0080FFFF"
		end
	end
	return color
end


local function getData(mode, submode, safemode)

	local game = getGame()
	local gen = getGen(game)
	local gamename = getGameName(game)
	local pointer = getPointer(game)
	local pidAddr = getPidAddr(game, pointer, mode, submode)
	local pid = memory.readdword(pidAddr)

	-- local trainerID = memory.readword(pointer + 0xD064) -- HeartGold only?
	-- local secretID = memory.readword(pointer + 0xD066) -- HeartGold only?
	-- local lotteryID = memory.readword(pointer + 0xDE4C) -- HeartGold only?

	local checksum = memory.readword(pidAddr + 6)
	local shiftvalue = (rshift((band(pid, 0x3E000)), 0xD)) % 24

	local BlockAoff = (ext.BlockA[shiftvalue + 1] - 1) * 32
	local BlockBoff = (ext.BlockB[shiftvalue + 1] - 1) * 32
	local BlockCoff = (ext.BlockC[shiftvalue + 1] - 1) * 32
	local BlockDoff = (ext.BlockD[shiftvalue + 1] - 1) * 32

	-- Block A
	local prng = checksum
	for _ = 1, ext.BlockA[shiftvalue + 1] - 1 do
		prng = mult32(prng,0x5F748241) + 0xCBA72510 -- 16 cycles
	end

	prng = mult32(prng,0x41C64E6D) + 0x6073
	local pokemonID = bxor(memory.readword(pidAddr + BlockAoff + 8), gettop(prng))
	if gen == 4 and safemode == 1 and pokemonID > 494 then --just to make sure pokemonID is right (gen 4)
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	elseif gen == 4 and isegg == 1 and (pokemonID == 0 or pokemonID > 495) then -- BUG: isegg is checked before defined below
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	elseif gen == 5 and pokemonID > 651 then -- gen5
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	end

	prng = mult32(prng,0x41C64E6D) + 0x6073
	local helditem = bxor(memory.readword(pidAddr + BlockAoff + 2 + 8), gettop(prng))
	if gen == 4 and safemode == 1 and helditem > 537 then -- Gen 4
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	elseif gen == 5 and helditem > 639 then -- Gen 5
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	end

	prng = mult32(prng,0x41C64E6D) + 0x6073
	local OTID = bxor(memory.readword(pidAddr + BlockAoff + 4 + 8), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local OTSID = bxor(memory.readword(pidAddr + BlockAoff + 6 + 8), gettop(prng))

	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local ability = bxor(memory.readword(pidAddr + BlockAoff + 12 + 8), gettop(prng))
	local friendship_or_steps_to_hatch = getbits(ability, 0, 8)
	ability = getbits(ability, 8, 8)
	if gen == 4 and safemode == 1 and ability > 123 then
		pokemonID = -1 -- (pokemonID = -1 indicates invalid data)
	elseif gen == 5 and ability > 164 then
		pokemonID = -1
	end
	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local evs1 = bxor(memory.readword(pidAddr + BlockAoff + 16 + 8), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local evs2 = bxor(memory.readword(pidAddr + BlockAoff + 18 + 8), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local evs3 = bxor(memory.readword(pidAddr + BlockAoff + 20 + 8), gettop(prng))

	local hpev = getbits(evs1, 0, 8)
	local atkev = getbits(evs1, 8, 8)
	local defev = getbits(evs2, 0, 8)
	local speev = getbits(evs2, 8, 8)
	local spaev = getbits(evs3, 0, 8)
	local spdev = getbits(evs3, 8, 8)

	-- Block B
	prng = checksum
	for _ = 1, ext.BlockB[shiftvalue + 1] - 1 do
		prng = mult32(prng,0x5F748241) + 0xCBA72510 -- 16 cycles
	end

	prng = mult32(prng,0x41C64E6D) + 0x6073

	local moves = {}

	moves[1] = bxor(memory.readword(pidAddr + BlockBoff + 8), gettop(prng))
	if safemode == 1 and gen == 4 and moves[1] > 467 then
		pokemonID = -1
	elseif gen == 5 and moves[1] > 559 then
		pokemonID = -1
	end
	prng = mult32(prng,0x41C64E6D) + 0x6073
	moves[2] = bxor(memory.readword(pidAddr + BlockBoff + 2 + 8), gettop(prng))
	if safemode == 1 and gen == 4 and moves[2] > 467 then
		pokemonID = -1
	elseif gen == 5 and moves[2] > 559 then
		pokemonID = -1
	end
	prng = mult32(prng,0x41C64E6D) + 0x6073
	moves[3] = bxor(memory.readword(pidAddr + BlockBoff + 4 + 8), gettop(prng))
	if safemode == 1 and gen == 4 and moves[3] > 467 then
		pokemonID = -1
	elseif gen == 5 and moves[3] > 559 then
		pokemonID = -1
	end
	prng = mult32(prng,0x41C64E6D) + 0x6073
	moves[4] = bxor(memory.readword(pidAddr + BlockBoff + 6 + 8), gettop(prng))
	if safemode == 1 and gen == 4 and moves[4] > 467 then
		pokemonID = -1
	elseif gen == 5 and moves[4] > 559 then
		pokemonID = -1
	end
	prng = mult32(prng,0x41C64E6D) + 0x6073

	local moveppaux = bxor(memory.readword(pidAddr + BlockBoff + 8 + 8), gettop(prng))

	local movespp = {}
	movespp[1] = getbits(moveppaux,0,8)
	movespp[2] = getbits(moveppaux,8,8)
	prng = mult32(prng,0x41C64E6D) + 0x6073
	moveppaux = bxor(memory.readword(pidAddr + BlockBoff + 10 + 8), gettop(prng))
	movespp[3] = getbits(moveppaux,0,8)
	movespp[4] = getbits(moveppaux,8,8)

	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073

	prng = mult32(prng,0x41C64E6D) + 0x6073

	local ivspart1 = bxor(memory.readword(pidAddr + BlockBoff + 16 + 8), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local ivspart2 = bxor(memory.readword(pidAddr + BlockBoff + 18 + 8), gettop(prng))
	local ivs = ivspart1  + lshift(ivspart2,16)

	local hpiv  = getbits(ivs,0,5)
	local atkiv = getbits(ivs,5,5)
	local defiv = getbits(ivs,10,5)
	local speiv = getbits(ivs,15,5)
	local spaiv = getbits(ivs,20,5)
	local spdiv = getbits(ivs,25,5)
	local isegg = getbits(ivs,30,1)

	-- Nature for gen 5, for gen 4, it's calculated from the PID.
	local nat
	if gen == 5 then
		prng = mult32(prng,0x41C64E6D) + 0x6073
		prng = mult32(prng,0x41C64E6D) + 0x6073
		prng = mult32(prng,0x41C64E6D) + 0x6073
		nat = bxor(memory.readword(pidAddr + BlockBoff + 24 + 8), gettop(prng))
		nat = getbits(nat,8,8)
		if nat > 24 then
			pokemonID = -1
		end
	else -- gen == 4
		nat = pid % 25
	end

	-- Block D
	prng = checksum
	for _ = 1, ext.BlockD[shiftvalue + 1] - 1 do
		prng = mult32(prng,0x5F748241) + 0xCBA72510 -- 16 cycles
	end

	prng = mult32(prng,0xCFDDDF21) + 0x67DBB608 -- 8 cycles
	prng = mult32(prng,0xEE067F11) + 0x31B0DDE4 -- 4 cycles
	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073

	local pkrs = bxor(memory.readword(pidAddr + BlockDoff + 0x1A + 8), gettop(prng))
	pkrs = getbits(pkrs,0,8)

	-- Current stats
	prng = pid
	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local level = getbits(bxor(memory.readword(pidAddr + 0x8C), gettop(prng)),0,8)
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local hpstat = bxor(memory.readword(pidAddr + 0x8E), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local maxhpstat = bxor(memory.readword(pidAddr + 0x90), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local atkstat = bxor(memory.readword(pidAddr + 0x92), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local defstat = bxor(memory.readword(pidAddr + 0x94), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local spestat = bxor(memory.readword(pidAddr + 0x96), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local spastat = bxor(memory.readword(pidAddr + 0x98), gettop(prng))
	prng = mult32(prng,0x41C64E6D) + 0x6073
	local spdstat = bxor(memory.readword(pidAddr + 0x9A), gettop(prng))

	local currentFoeHP = getCurFoeHP(game, pointer, mode)
	if currentFoeHP > 1000 then
		currentFoeHP = 0
	end

	-- Calculate Hidden Power
	local hiddentype = math.floor(
		((hpiv % 2) + 2*(atkiv % 2) + 4*(defiv % 2) + 8*(speiv % 2) + 16*(spaiv % 2) + 32*(spdiv % 2))*15 / 63
	)

	local hiddenpower = 30 + math.floor(((rshift(hpiv,1) % 2) + 2*(rshift(atkiv,1) % 2) + 4*(rshift(defiv,1) % 2)
					+ 8*(rshift(speiv,1) % 2) + 16*(rshift(spaiv,1) % 2) + 32*(rshift(spdiv,1) % 2)) * 40 / 63)

	local movestext = {}
	for i, move in ipairs(moves) do
		movestext[i] = ext.movename[move + 1] or move
	end

	return {
		gamename = gamename,
		pokemonID = pokemonID,
		gen = gen,
		pid = pid,
		isegg = isegg,
		helditem = helditem,
		OTID = OTID,
		OTSID = OTSID,
		ability = ability,
		nat = nat,
		level = level,
		hpstat = hpstat,
		maxhpstat = maxhpstat,
		atkstat = atkstat,
		defstat = defstat,
		spestat = spestat,
		spastat = spastat,
		spdstat = spdstat,
		pkrs = pkrs,
		hiddentype = hiddentype,
		hiddenpower = hiddenpower,
		currentFoeHP = currentFoeHP,
		friendship_or_steps_to_hatch = friendship_or_steps_to_hatch,
		hpev = hpev,
		atkev = atkev,
		defev = defev,
		speev = speev,
		spaev = spaev,
		spdev = spdev,
		hpiv = hpiv,
		atkiv = atkiv,
		defiv = defiv,
		speiv = speiv,
		spaiv = spaiv,
		spdiv = spdiv,
		moves = moves,
		movespp = movespp,
		movestext = movestext,
		mode = mode,
		submode = submode,
		safemode = safemode,
		helditemtext = (gen == 4 and ext.item_gen4[helditem + 1]) or (gen == 5 and ext.item_gen5[helditem + 1]) or helditem,
		pokemontext = ext.pokemon[pokemonID + 1] or pokemonID,
		naturetext = ext.nature[nat + 1] or nat,
		abilitytext = ext.abilities[ability + 1] or ability,
		modetext = ext.mode[mode] or mode,
	}

end

local mode = 1
local safemode = 1
local submode = 1
local modemax = 5
local submodemax = 6
local prev = {}

local t = os.clock()

local function dump()

	if os.clock() - t < ticklength then
		return
	end
	t = os.clock()

	local tbl = {}
    local i = 0
	-- for i = 1, modemax do
		tbl[i] = {}
		for j = 1, submodemax do
			data = getData(i, j, safemode)
            tbl[i][j] = data
		end
	-- end
	local f = io.open('dump.json', 'w')
	f:write(json.encode(tbl[i], {indent = indentjson}))
	f:close()

end

local function main()

	dump()

    --[[
	local tabl = input.get()

	if tabl["7"] and not prev["7"] and mode < 5 then
		submode = submode - 1
		if submode == 0 then
			submode = submodemax
		end
	end

	if tabl["8"] and not prev["8"] and mode < 5 then
		submode = submode + 1
		if submode == submodemax + 1 then
			submode = 1
		end
	end

	if tabl["3"] and not prev["3"] then
		mode = mode - 1
		if mode == 0 then
			mode = modemax
		end
	end
	if tabl["4"] and not prev["4"] then
		mode = mode + 1
		if mode == modemax + 1 then
			mode = 1
		end
	end

	if tabl["1"] and not prev["1"] then
		safemode=safemode*-1
	end

	if tabl["0"] and not prev["0"] then
		if yfix == 10 then
			yfix = -185
		else
			yfix = 10
		end
	end

	if tabl['leftclick'] and not prev['leftclick'] then
		local x = tabl['xmouse']
		local y = tabl['ymouse']
		if x > 88 and x < 98 and y > 10 and y < 17 then
			mode = mode - 1
			if mode == 0 then
				mode = modemax
			end
		end
		if x > 152 and x < 162 and y > 10 and y < 17 then
			mode = mode + 1
			if mode == modemax + 1 then
				mode = 1
			end
		end
		if x > 109 and x < 119 and y > 20 and y < 27 then
			submode = submode - 1
			if submode == 0 then
				submode = submodemax
			end
		end
		if x > 132 and x < 142 and y > 20 and y < 27 then
			submode = submode + 1
			if submode == submodemax + 1 then
				submode = 1
			end
		end
		-- if x > 10 and x < 42 and y > 10 and y < 25 then
		-- 	dump()
		-- end
	end

	prev = tabl

	local data = getData(mode, submode, safemode)

	-- Display data
	drawbox(-5,-5,240,175,"#000000A0", "white")

	-- drawbox(0, 0, 32, 15, "#000000A0", "white")
	-- drawtext(5, 4, "Dump", "white")

	drawtext(180,0, data.gamename, "#FF88FFFF")
	drawtext(182,10, "mode", "#FF88FFFF")

	drawarrowleft(98 - math.floor(string.len(data.modetext)/2) * 6,0, "white")
	drawtext(112 - math.floor(string.len(data.modetext)/2) * 6,0, data.modetext)
	drawarrowright(133 + math.floor(string.len(data.modetext)/2) * 6,0, "white")
	if (mode < 5) then
		drawarrowleft(100,10, "white")
		drawtext(100,10, "  " .. submode)
		drawarrowright(130,10, "white")
	end
	--drawtext(0,0, bit.tohex(pointer))
	if data.pokemonID == -1 then
		drawtext(55,30, "Invalid Pokemon Data", "red")
		if data.gen == 4 then
			if safemode == 1 then
				drawtext(75,60, "Safe mode: ON")
			else
				drawtext(75,60, "Safe mode: OFF")
			end
			drawtext(3,80, "Press 1 to turn on/off the safe mode to")
			drawtext(35,90, "display possible glitch Pokemon.")
			drawtext(75,100, "Use at own risk.")
		end
	else
		drawtext(0,25, "Pokemon: " .. data.pokemontext, "yellow")
		drawtext(0,35, "PID : " .. bit.tohex(data.pid), "magenta")
		drawtext(0,45, "Item: " .. data.helditemtext, "white")
		drawtext(0,55, "OT  ID: " .. data.OTID, "orange")
		drawtext(0,65, "OT SID: " .. data.OTSID, "cyan")
		drawtext(0,75, "Nature: " .. data.naturetext, "teal")
		drawtext(0,85, "Ability: " .. data.abilitytext)

		drawtext(140,30, "Level: " .. data.level, "green")
		--Current foe is not available for gen 5 yet.
		if mode == 1 then
			drawtext(140,40, "HP: " .. data.hpstat .. "/" .. data.maxhpstat, "green")
		elseif mode == 4 and data.gen == 4 then --Partner
			drawtext(105,165, "Cur. partner's HP: " .. data.currentFoeHP, "green")
		elseif data.gen == 4 then --Enemy / Enemy 2 / Wild
			drawtext(110,165, "Current foe's HP: " .. data.currentFoeHP, "green")

		end
		if data.pkrs == 0 then
			drawtext(140,50, "PKRS: no", "red")
		else
			drawtext(140,50, "PKRS: yes (" .. data.pkrs .. ")", "red")
		end
		drawtext(140,60, "Hidden Power: ", "cyan")
		drawtext(140,70, ext.pkmntype[data.hiddentype+1] .. " " .. data.hiddenpower, "cyan")
		if data.isegg == 0 then
			drawtext(140,80, "Friendship: " .. data.friendship_or_steps_to_hatch, "orange")
		else
			drawtext(140,80, "Steps to hatch: ", "orange")
			drawtext(140,90, data.friendship_or_steps_to_hatch * 256 .. "-" .. (data.friendship_or_steps_to_hatch + 1) * 256 .. " steps", "orange")
		end

		drawtext(0,115, "HP", "yellow")
		drawtext(0,125,"ATK", getNatClr("atk", data.nat))
		drawtext(0,135,"DEF", getNatClr("def", data.nat))
		drawtext(0,145,"SAT", getNatClr("spa", data.nat))
		drawtext(0,155,"SDF", getNatClr("spd", data.nat))
		drawtext(0,165,"SPE", getNatClr("spe", data.nat))

		drawtext(30,105, "IV", "white")
		drawtext(30,115, data.hpiv, "yellow")
		drawtext(30,125, data.atkiv, getNatClr("atk", data.nat))
		drawtext(30,135, data.defiv, getNatClr("def", data.nat))
		drawtext(30,145, data.spaiv, getNatClr("spa", data.nat))
		drawtext(30,155, data.spdiv, getNatClr("spd", data.nat))
		drawtext(30,165, data.speiv, getNatClr("spe", data.nat))

		drawtext(55,105, "EV", "white")
		drawtext(55,115, data.hpev, "yellow")
		drawtext(55,125, data.atkev, getNatClr("atk", data.nat))
		drawtext(55,135, data.defev, getNatClr("def", data.nat))
		drawtext(55,145, data.spaev, getNatClr("spa", data.nat))
		drawtext(55,155, data.spdev, getNatClr("spd", data.nat))
		drawtext(55,165, data.speev, getNatClr("spe", data.nat))

		drawtext(80,105, "STAT", "white")
		drawtext(80,115, data.maxhpstat, "yellow")
		drawtext(80,125, data.atkstat, getNatClr("atk", data.nat))
		drawtext(80,135, data.defstat, getNatClr("def", data.nat))
		drawtext(80,145, data.spastat, getNatClr("spa", data.nat))
		drawtext(80,155, data.spdstat, getNatClr("spd", data.nat))
		drawtext(80,165, data.spestat, getNatClr("spe", data.nat))

		drawtext(110,105, "  MOVES", "white")
		drawtext(110,115, "1.".. data.movestext[1], "yellow")
		drawtext(110,125, "2.".. data.movestext[2], "yellow")
		drawtext(110,135, "3.".. data.movestext[3], "yellow")
		drawtext(110,145, "4.".. data.movestext[4], "yellow")

		drawtext(210,105,  "PP", "white")
		drawtext(210,115, data.movespp[1], "yellow")
		drawtext(210,125, data.movespp[2], "yellow")
		drawtext(210,135, data.movespp[3], "yellow")
		drawtext(210,145, data.movespp[4], "yellow")
	end
    --]]
end

gui.register(main)
