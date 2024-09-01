-- Made by Unknown_Warrior, cobbled together from coding blatantly nicked from both /u/hourglasseye (https://www.reddit.com/r/pokemonrng/comments/1xnqys/5th_simple_lua_script_for_pid_advancement/?ref=share&ref_source=link) and Real96 (https://github.com/DevonStudios/LuaScripts)
-- Bizhawk version ported by Real96 and SexyMalasada
-- INSTRUCTIONS: Edit the "maxAdvances" in this lua. 
-- INSTRUCTIONS Ingame: place two Chatot next to each other with customised Chatter and run and to start at the second one.
-- English versions only for now

mdword=memory.read_u32_le
mword = memory.read_u16_le
mbyte = memory.readbyte

local maxAdvances = 2500 -- how many advances you want the script to make

-- Detect Game Version
if mdword(0x02FFFE0C) == 0x45555043 then -- Game: Platinum
	off = 0			-- Initial/Current Seed
	currgen = 4
	game = "Platinum"
elseif mdword(0x02FFFE0C) == 0x45414441 or mdword(0x02FFFE0C) == 0x45415041 then -- game: Diamond/Pearl
	off = 0x5234
	currgen = 4
	game = "Diamond/Pearl"
elseif mword(0x02FFFE0C) == 0x5049 then -- game: HGSS
	off = 0x11A94	
	currgen = 4
	game = "HGSS"
elseif mbyte(0x02FFFE0E) == 0x41 then -- game: White
	prng = 0x02216244
	currgen = 5
	game = "Black/White"
elseif mbyte(0x02FFFE0E) == 0x42 then -- Game: Black
	prng = 0x02216224
	currgen = 5
	game = "Black/White"
elseif mbyte(0x02FFFE0E) == 0x44 then -- game: White2
	prng = 0x021FFC58
	currgen = 5
	game = "B2W2"
elseif mbyte(0x02FFFE0E) == 0x45 then -- game: Black2
	prng = 0x021FFC18
	currgen = 5
	game = "B2W2"
end

local runbtn = 0
local flipbtn = -1

local pidAdvances = 0
local flip = 0
local memadv = 1
local btmcheck = 0
local currseed
local RNGstate = 0
local i = 0
local errside = 0

while true do
	if currgen == 4 then
		RNGstate = mdword(0x021BFB14+off)
	elseif currgen == 5 then
		RNGstate = mdword(prng)
	end
	
	key = input.get()
	if key["Number0"] or key["Keypad0"] then
		runbtn = 1
	end
	if key["Number9"] or key["Keypad9"] then
		flipbtn = -1*flipbtn
	end
	
	if runbtn == 0 then
		gui.text(1,(384+flipbtn*320),"Press 0 to run, advances set: "..maxAdvances,"cyan")
		gui.text(1,(384+flipbtn*300),"Press 9 to switch screens","cyan")
	elseif runbtn == 1 then
		if pidAdvances <= maxAdvances then
			if RNGstate ~= currseed then
				flip = 1 - flip
				currseed = RNGstate
				errside = 0
				pidAdvances = pidAdvances+1
			end

			if errside >=100 then
				btmcheck = 0
				errside = 0
				flip = 0
				memadv = 1
				i = 0
			elseif errside >= 20 then
				btmcheck = 0
			end
			
			if btmcheck == 0 then
				if memadv ~= pidAdvances then
					btmcheck = 1
					memadv = pidAdvances
					errside = 0
				elseif i>= 90 then
					btmcheck = 1
				end
				i=i+1
				joypad.set({Down=1})
			end		
			
			if flip == 1 and btmcheck == 1 then
				joypad.set({Up=1})
				errside = errside +1
			elseif flip == 0 and btmcheck == 1 then
				joypad.set({Down=1})
				errside = errside + 1
			end		
			gui.text(1, (384+flipbtn*320), "Advances: " .. pidAdvances-1, "cyan")
		else
			gui.text(1, (384+flipbtn*320), "Advances: " .. pidAdvances-1 .. ", DONE!","cyan")
		end
	end
	gui.text(1,(384+flipbtn*340),"Game: "..game,"cyan")
	emu.frameadvance()
end