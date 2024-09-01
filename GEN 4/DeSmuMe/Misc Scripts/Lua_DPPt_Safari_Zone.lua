-- Generation 4 Great Marsh/Safari Zone Checker
-- Source DPP slots: https://projectpokemon.org/home/forums/topic/60922-pokemon-dp-great-marsh-swarm-trophy-garden-finds/

mdword = memory.readdwordunsigned
mword = memory.readword
mbyte = memory.readbyte
rshift = bit.rshift
band = bit.band

local game
local pointer
local zones = {"Plains" , "Meadow", "Savannah" , "Peak" , "Rocky Beach" , "Wetland", "Forest" , "Swamp" , "Marshland" , "Wasteland" , "Mountain" , "Desert"}
local offset 

local marshdp = {"Croagunk" , "Skorupi" , "Carnivine" , "Croagunk" , "Skorupi" , "Carnivine" , "Golduck" , "Croagunk" , "Skorupi" , "Carnivine" , "Roselia" , "Staravia" , "Toxicroak" , "Drapion" , "Exeggcute" , "Golduck" , "Staravia" , "Croagunk" , "Skorupi" , "Carnivine" , "Yanma" , "Shroomish" , "Paras" , "Kangaskhan" , "Gulpin" , "Roselia" , "Staravia" , "Croagunk" , "Skorupi" , "Carnivine" , "Roselia" , "Golduck"}
local marshpt = {"Toxicroak" , "Kecleon" , "Kecleon" , "Carnivine" , "Skorupi" , "Croagunk" , "Quagsire" , "Drapion" , "Skorupi" , "Croagunk" , "Quagsire" , "Kangaskhan" , "Paras" , "Drapion" , "Exeggcute" , "Exeggcute" , "Skorupi" , "Croagunk" , "Skorupi" , "Carnivine" , "Yanma" , "Shroomish" , "Paras" , "Kangaskhan" , "Gulpin" , "Tropius" , "Gulpin" , "Shroomish" , "Skorupi" , "Carnivine" , "Croagunk" , "Tangela"}
local trophydp = {"Eevee" , "Bonsly" , "Happiny" , "Meowth" , "Cleffa" , "Clefairy" , "Igglybuff" , "Plusle" , "Jigglypuff" , "Porygon" , "Castform" , "Minun" , "Mime Jr" , "Marill" , "Chansey" , "Azurill"}
local trophypt = {"Eevee" , "Bonsly" , "Happiny" , "Meowth" , "Cleffa" , "Clefairy" , "Igglybuff" , "Plusle" , "Jigglypuff" , "Ditto" , "Castform" , "Minun" , "Mime Jr" , "Marill" , "Chansey" , "Azurill"}

local stepc = 0
local marsh
local marsh_poke1
local marsh_poke2
local marsh_poke3
local marsh_poke4
local marsh_poke5
local marsh_poke6
local trophy1
local trophy2

local slot = 0
local key = {}
local prevKey = {}
local mode=1
local oldmode=1
local i=0
local days = 0
local sc_plains = 0
local sc_forest = 0
local sc_rocks = 0
local sc_water = 0
local mp_plains = 1
local mp_forest = 1
local mp_rocks = 1
local mp_water = 1
local index=0

-- Detect game
if mdword(0x02FFFE0C) == 0x45414441 or mdword(0x02FFFE0C) == 0x45415041 then
		game = 1 -- Diamond/Pearl
		pointer = mdword(0x02106FAC)
elseif mdword(0x02FFFE0C) == 0x45555043 then
		game = 2 -- Platinum
		pointer = mdword(0x02101D2C)
else
		game = 3 -- HeartGold/SoulSilver
		pointer = mdword(0x0211186C)
		offset = 0xCFE0
end



function main()

if game == 1 then

		gui.text(25, -140, string.format("Trophy Garden"),"cyan")
		gui.text(25, -70, string.format("Great Marsh"),"cyan")
	
		stepc = mword(pointer + 0xE4E2)
		marsh = mdword(pointer + 0x144E4)
		trophy1 = mword(pointer + 0x144F0)
		trophy2 = mword(pointer + 0x144F2)
		
		marsh_poke1 = band(marsh, 0x1f)
		marsh_poke2 = band(rshift(marsh,5),0x1f)
		marsh_poke3 = band(rshift(marsh,10),0x1f)
		marsh_poke4 = band(rshift(marsh,15),0x1f)
		marsh_poke5 = band(rshift(marsh,20),0x1f)
		marsh_poke6 = band(rshift(marsh,25),0x1f)
		
		gui.text(10,-125, string.format("Slot 6:"),"yellow")
		gui.text(10,-115, string.format("Slot 7:"),"yellow")
		
		if trophy1 == 0xFFFF then
			gui.text(55,-125, string.format("Default"))
		else
			gui.text(55, -125,trophydp[trophy1+1])			
		end
		if trophy2 == 0xFFFF then
			gui.text(55,-115, string.format("Default"))
		else
			gui.text(55, -115,trophydp[trophy2+1])			
		end
		
		if stepc ~= 0 then
			gui.text(10, -55, string.format("Steps left: "),"teal")
			gui.text(85, -55, string.format("%d", 500-stepc))
		end

		gui.text(75,-35, string.format(":Area 1 | Area 2:"),"yellow")	
		gui.text(75,-25, string.format(":Area 3 | Area 4:"),"yellow")	
		gui.text(75,-15, string.format(":Area 5 | Area 6:"),"yellow")

		gui.text(10, -35,marshdp[marsh_poke1+1])	
		gui.text(180, -35,marshdp[marsh_poke2+1])	
		gui.text(10, -25,marshdp[marsh_poke3+1])	
		gui.text(180, -25,marshdp[marsh_poke4+1])	
		gui.text(10, -15,marshdp[marsh_poke5+1])	
		gui.text(180, -15,marshdp[marsh_poke6+1])
		
elseif game == 2 then

		gui.text(25, -140, string.format("Trophy Garden"),"cyan")
		gui.text(25, -70, string.format("Great Marsh"),"cyan")
	
		stepc = mword(pointer + 0xE30A)
		marsh = mdword(pointer + 0x14F18)
		trophy1 = mword(pointer + 0x14F24)
		trophy2 = mword(pointer + 0x14F26)
		
		marsh_poke1 = band(marsh, 0x1f)
		marsh_poke2 = band(rshift(marsh,5),0x1f)
		marsh_poke3 = band(rshift(marsh,10),0x1f)
		marsh_poke4 = band(rshift(marsh,15),0x1f)
		marsh_poke5 = band(rshift(marsh,20),0x1f)
		marsh_poke6 = band(rshift(marsh,25),0x1f)
		
		gui.text(10,-125, string.format("Slot 6:"),"yellow")
		gui.text(10,-115, string.format("Slot 7:"),"yellow")
		
		if trophy1 == 0xFFFF then
			gui.text(55,-125, string.format("Default"))
		else
			gui.text(55, -125,trophypt[trophy1+1])			
		end
		if trophy2 == 0xFFFF then
			gui.text(55,-115, string.format("Default"))
		else
			gui.text(55, -115,trophypt[trophy2+1])			
		end
		
		if stepc ~= 0 then
			gui.text(10, -55, string.format("Steps left: "),"teal")
			gui.text(85, -55, string.format("%d", 500-stepc))
		end 

		gui.text(75,-35, string.format(":Area 1 | Area 2:"),"yellow")	
		gui.text(75,-25, string.format(":Area 3 | Area 4:"),"yellow")	
		gui.text(75,-15, string.format(":Area 5 | Area 6:"),"yellow")

		gui.text(10, -35,marshpt[marsh_poke1+1])	
		gui.text(180, -35,marshpt[marsh_poke2+1])	
		gui.text(10, -25,marshpt[marsh_poke3+1])	
		gui.text(180, -25,marshpt[marsh_poke4+1])	
		gui.text(10, -15,marshpt[marsh_poke5+1])	
		gui.text(180, -15,marshpt[marsh_poke6+1])

else

	--Key input detection
	 key = input.get()
	 if key["1"] and not prevKey["1"] then
	  mode = mode - 1
	  if mode < 1 then
	   mode = 7
	  end
	 elseif key["2"] and not prevKey["2"] then
	  mode = mode + 1
	  if mode > 7 then
	   mode = 1
	  end
	 end
	 
	 prevKey = key
	 
	 gui.text(110, -180, "<- 1 - 2 ->")

	slot = pointer + 0x1912c + (mode-2)*0x7A
	base = (pointer+offset)

	 function BlockCounter() --Counts the number of blocks in a specific zone and keeps a tally for every relevant category (plains, forest, rock, water)
		 while i < mbyte(slot+0x1) do
			if mbyte(slot+0x2+i*4) >=0 and mbyte(slot+0x2+i*4) <3 and mbyte(slot+0x1) ~= 0 then
				sc_plains = sc_plains+1
			elseif mbyte(slot+0x2+i*4) >=3 and mbyte(slot+0x2+i*4) <6 then
				sc_forest = sc_forest+1
			elseif mbyte(slot+0x2+i*4) >=6 and mbyte(slot+0x2+i*4) <9 then
				sc_rocks = sc_rocks+1
			elseif mbyte(slot+0x2+i*4) >=9 and mbyte(slot+0x2+i*4) <12 then
				sc_water=sc_water+1
			end
			i=i+1
		end
	end

	if mode==1 then 
		 gui.text(2, -170, string.format("Days passed:"),"cyan")

		 gui.text(30, -60, string.format("Plains:"),"yellow") 
		 gui.text(30, -50, string.format("Meadow:"),"yellow") 
		 gui.text(30, -40, string.format("Savannah:"),"yellow") 
		 gui.text(30, -30, string.format("Peak:"),"yellow") 
		 gui.text(30, -20, string.format("Rocky Beach:"),"yellow") 
		 gui.text(30, -10, string.format("Wetland:"),"yellow") 

		 gui.text(105, -60, string.format("%d", mbyte(base+0xC428)))
		 gui.text(105, -50, string.format("%d", mbyte(base+0xC429)))
		 gui.text(105, -40, string.format("%d", mbyte(base+0xC42A)))
		 gui.text(105, -30, string.format("%d", mbyte(base+0xC42B)))
		 gui.text(105, -20, string.format("%d", mbyte(base+0xC42C)))
		 gui.text(105, -10, string.format("%d", mbyte(base+0xC42D)))
		 
		 gui.text(150, -60, string.format("Forest:"),"yellow") 
		 gui.text(150, -50, string.format("Swamp:"),"yellow") 
		 gui.text(150, -40, string.format("Marshland:"),"yellow") 
		 gui.text(150, -30, string.format("Wasteland:"),"yellow") 
		 gui.text(150, -20, string.format("Mountain:"),"yellow") 
		 gui.text(150, -10, string.format("Desert:"),"yellow") 
		 
		 gui.text(225, -60, string.format("%d", mbyte(base+0xC42E)))
		 gui.text(225, -50, string.format("%d", mbyte(base+0xC42F)))
		 gui.text(225, -40, string.format("%d", mbyte(base+0xC430)))
		 gui.text(225, -30, string.format("%d", mbyte(base+0xC431)))
		 gui.text(225, -20, string.format("%d", mbyte(base+0xC432)))
		 gui.text(225, -10, string.format("%d", mbyte(base+0xC433)))
		
		else
		 gui.text(2, -170, string.format("Safari Zone %d",mode-1),"cyan")
		
		if mode ~= oldmode then
			i=0
			sc_plains=0
			sc_forest=0
			sc_rocks=0
			sc_water=0
			mp_plains=1
			mp_forest=1
			mp_rocks=1
			mp_water=1
			oldmode=mode
		end
		
		BlockCounter()
		
		days = mbyte(base + 0xC428 + mbyte(slot)) 
		
		if days >= 10 and days <50 then
			mp_plains = 2
		elseif days >=250 then
			mp_plains = 7
		elseif days >=50 then
			mp_plains = math.floor(days/50+2)
		end
		
		if days >= 20 and days <60 then
			mp_forest = 2
		elseif days >=250 then
			mp_forest = 7
		elseif days >=60 then
			mp_forest = math.floor((days-10)/50+2)
		end

		if days >= 30 and days <70 then
			mp_rocks = 2
		elseif days >=250 then
			mp_rocks = 7
		elseif days >=70 then
			mp_rocks = math.floor((days-20)/50+2)
		end

		if days >= 40 and days <80 then
			mp_water = 2
		elseif days >=250 then
			mp_water = 7
		elseif days >=80 then
			mp_water = math.floor((days-30)/50+2)
		end
		 
		 gui.text(30, -75, string.format("Zone:"),"red")
		 gui.text(70, -75,zones[mbyte(slot)+1])
		 
		 gui.text(40, -55, string.format("Days:"),"teal")
		 gui.text(75, -55, string.format("%d", days))	 
		 
		 gui.text(40, -40, string.format("Plains score:"),"yellow")
		 gui.text(130, -40, string.format("%d", sc_plains*mp_plains))
		 
		 gui.text(40, -30, string.format("Forest score:"),"yellow")
		 gui.text(130, -30, string.format("%d", sc_forest*mp_forest))
		 
		 gui.text(40, -20, string.format("Peak score:"),"yellow")
		 gui.text(130, -20, string.format("%d", sc_rocks*mp_rocks))

		 gui.text(40, -10, string.format("Waters. score:"),"yellow")
		 gui.text(130, -10, string.format("%d", sc_water*mp_water))

		end
	end
end

gui.register(main)
