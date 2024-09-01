-- HGSS Safari Zone Checker

mdword = memory.readdwordunsigned
mword = memory.readword
mbyte = memory.readbyte


local pointer = mdword(0x0211186C)
local zones = {"Plains" , "Meadow", "Savannah" , "Peak" , "Rocky Beach" , "Wetland", "Forest" , "Swamp" , "Marshland" , "Wasteland" , "Mountain" , "Desert"}
local offset= 0xCFE0
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


function main()

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

 gui.text(110, -180, "<- 1 - 2 ->")
 

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

gui.register(main)
