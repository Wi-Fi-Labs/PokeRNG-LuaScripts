read32Bit = memory.read_u32_le
read16Bit = memory.read_u16_le
read8Bit = memory.readbyte
rshift = bit.rshift
lshift = bit.lshift
bxor = bit.bxor
band = bit.band
floor = math.floor
sqrt = math.sqrt

local natureNamesList = {
 "Hardy", "Lonely", "Brave", "Adamant", "Naughty",
 "Bold", "Docile", "Relaxed", "Impish", "Lax",
 "Timid", "Hasty", "Serious", "Jolly", "Naive",
 "Modest", "Mild", "Quiet", "Bashful", "Rash",
 "Calm", "Gentle", "Sassy", "Careful", "Quirky"}

local HPTypeNamesList = {
 "Fighting", "Flying", "Poison", "Ground",
 "Rock", "Bug", "Ghost", "Steel",
 "Fire", "Water", "Grass", "Electric",
 "Psychic", "Ice", "Dragon", "Dark"}

local speciesNamesList = {
 -- Gen 1
 "Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise",
 "Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata",
 "Raticate", "Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "Nidoran♀",
 "Nidorina", "Nidoqueen", "Nidoran♂", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Vulpix", "Ninetales",
 "Jigglypuff", "Wigglytuff", "Zubat", "Golbat", "Oddish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat",
 "Venomoth", "Diglett", "Dugtrio", "Meowth", "Persian", "Psyduck", "Golduck", "Mankey", "Primeape", "Growlithe",
 "Arcanine", "Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam", "Machop", "Machoke", "Machamp",
 "Bellsprout", "Weepinbell", "Victreebel", "Tentacool", "Tentacruel", "Geodude", "Graveler", "Golem", "Ponyta",
 "Rapidash", "Slowpoke", "Slowbro", "Magnemite", "Magneton", "Farfetch'd", "Doduo", "Dodrio", "Seel", "Dewgong",
 "Grimer", "Muk", "Shellder", "Cloyster", "Gastly", "Haunter", "Gengar", "Onix", "Drowzee", "Hypno", "Krabby",
 "Kingler", "Voltorb", "Electrode", "Exeggcute", "Exeggutor", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan",
 "Lickitung", "Koffing", "Weezing", "Rhyhorn", "Rhydon", "Chansey", "Tangela", "Kangaskhan", "Horsea", "Seadra",
 "Goldeen", "Seaking", "Staryu", "Starmie", "Mr. Mime", "Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir",
 "Tauros", "Magikarp", "Gyarados", "Lapras", "Ditto", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Porygon",
 "Omanyte", "Omastar", "Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini",
 "Dragonair", "Dragonite", "Mewtwo", "Mew",
 -- Gen 2
 "Chikorita", "Bayleef", "Meganium", "Cyndaquil", "Quilava", "Typhlosion", "Totodile", "Croconaw", "Feraligatr",
 "Sentret", "Furret", "Hoothoot", "Noctowl", "Ledyba", "Ledian", "Spinarak", "Ariados", "Crobat", "Chinchou",
 "Lanturn", "Pichu", "Cleffa", "Igglybuff", "Togepi", "Togetic", "Natu", "Xatu", "Mareep", "Flaaffy", "Ampharos",
 "Bellossom", "Marill", "Azumarill", "Sudowoodo", "Politoed", "Hoppip", "Skiploom", "Jumpluff", "Aipom", "Sunkern",
 "Sunflora", "Yanma", "Wooper", "Quagsire", "Espeon", "Umbreon", "Murkrow", "Slowking", "Misdreavus", "Unown",
 "Wobbuffet", "Girafarig", "Pineco", "Forretress", "Dunsparce", "Gligar", "Steelix", "Snubbull", "Granbull",
 "Qwilfish", "Scizor", "Shuckle", "Heracross", "Sneasel", "Teddiursa", "Ursaring", "Slugma", "Magcargo", "Swinub",
 "Piloswine", "Corsola", "Remoraid", "Octillery", "Delibird", "Mantine", "Skarmory", "Houndour", "Houndoom",
 "Kingdra", "Phanpy", "Donphan", "Porygon2", "Stantler", "Smeargle", "Tyrogue", "Hitmontop", "Smoochum", "Elekid",
 "Magby", "Miltank", "Blissey", "Raikou", "Entei", "Suicune", "Larvitar", "Pupitar", "Tyranitar", "Lugia", "Ho-Oh",
 "Celebi",
 -- Gen 3
 "Treecko", "Grovyle", "Sceptile", "Torchic", "Combusken", "Blaziken", "Mudkip", "Marshtomp", "Swampert",
 "Poochyena", "Mightyena", "Zigzagoon", "Linoone", "Wurmple", "Silcoon", "Beautifly", "Cascoon", "Dustox", "Lotad",
 "Lombre", "Ludicolo", "Seedot", "Nuzleaf", "Shiftry", "Taillow", "Swellow", "Wingull", "Pelipper", "Ralts",
 "Kirlia", "Gardevoir", "Surskit", "Masquerain", "Shroomish", "Breloom", "Slakoth", "Vigoroth", "Slaking",
 "Nincada", "Ninjask", "Shedinja", "Whismur", "Loudred", "Exploud", "Makuhita", "Hariyama", "Azurill", "Nosepass",
 "Skitty", "Delcatty", "Sableye", "Mawile", "Aron", "Lairon", "Aggron", "Meditite", "Medicham", "Electrike",
 "Manectric", "Plusle", "Minun", "Volbeat", "Illumise", "Roselia", "Gulpin", "Swalot", "Carvanha", "Sharpedo",
 "Wailmer", "Wailord", "Numel", "Camerupt", "Torkoal", "Spoink", "Grumpig", "Spinda", "Trapinch", "Vibrava",
 "Flygon", "Cacnea", "Cacturne", "Swablu", "Altaria", "Zangoose", "Seviper", "Lunatone", "Solrock", "Barboach",
 "Whiscash", "Corphish", "Crawdaunt", "Baltoy", "Claydol", "Lileep", "Cradily", "Anorith", "Armaldo", "Feebas",
 "Milotic", "Castform", "Kecleon", "Shuppet", "Banette", "Duskull", "Dusclops", "Tropius", "Chimecho", "Absol",
 "Wynaut", "Snorunt", "Glalie", "Spheal", "Sealeo", "Walrein", "Clamperl", "Huntail", "Gorebyss", "Relicanth",
 "Luvdisc", "Bagon", "Shelgon", "Salamence", "Beldum", "Metang", "Metagross", "Regirock", "Regice", "Registeel",
 "Latias", "Latios",  "Kyogre", "Groudon", "Rayquaza", "Jirachi", "Deoxys"}

local abilityNamesList = {
 "Stench", "Drizzle", "Speed Boost", "Battle Armor", "Sturdy", "Damp", "Limber", "Sand Veil", "Static",
 "Volt Absorb", "Water Absorb", "Oblivious", "Cloud Nine", "Compound Eyes", "Insomnia", "Color Change", "Immunity",
 "Flash Fire", "Shield Dust", "Own Tempo", "Suction Cups", "Intimidate", "Shadow Tag", "Rough Skin", "Wonder Guard",
 "Levitate", "Effect Spore", "Synchronize", "Clear Body", "Natural Cure", "Lightning Rod", "Serene Grace",
 "Swift Swim", "Chlorophyll", "Illuminate", "Trace", "Huge Power", "Poison Point", "Inner Focus", "Magma Armor",
 "Water Veil", "Magnet Pull", "Soundproof", "Rain Dish", "Sand Stream", "Pressure", "Thick Fat", "Early Bird",
 "Flame Body", "Run Away", "Keen Eye", "Hyper Cutter", "Pickup", "Truant", "Hustle", "Cute Charm", "Plus", "Minus",
 "Forecast", "Sticky Hold", "Shed Skin", "Guts", "Marvel Scale", "Liquid Ooze", "Overgrow", "Blaze", "Torrent",
 "Swarm", "Rock Head", "Drought", "Arena Trap", "Vital Spirit", "White Smoke", "Pure Power", "Shell Armor",
 "Cacophony", "Air Lock"}

local moveNamesList = {
 "--" , "Pound", "Karate Chop", "Double Slap", "Comet Punch", "Mega Punch", "Pay Day", "Fire Punch", "Ice Punch",
 "Thunder Punch", "Scratch", "Vice Grip", "Guillotine", "Razor Wind", "Swords Dance", "Cut", "Gust", "Wing Attack",
 "Whirlwind", "Fly", "Bind", "Slam", "Vine Whip", "Stomp", "Double Kick", "Mega Kick", "Jump Kick", "Rolling Kick",
 "Sand Attack", "Headbutt", "Horn Attack", "Fury Attack", "Horn Drill", "Tackle", "Body Slam", "Wrap", "Take Down",
 "Thrash", "Double-Edge", "Tail Whip", "Poison Sting", "Twineedle", "Pin Missile", "Leer", "Bite", "Growl", "Roar",
 "Sing", "Supersonic", "Sonic Boom", "Disable", "Acid", "Ember", "Flamethrower", "Mist", "Water Gun", "Hydro Pump",
 "Surf", "Ice Beam", "Blizzard", "Psybeam", "Bubble Beam", "Aurora Beam", "Hyper Beam", "Peck", "Drill Peck",
 "Submission", "Low Kick", "Counter", "Seismic Toss", "Strength", "Absorb", "Mega Drain", "Leech Seed", "Growth",
 "Razor Leaf", "Solar Beam", "Poison Powder", "Stun Spore", "Sleep Powder", "Petal Dance", "String Shot",
 "Dragon Rage", "Fire Spin", "Thunder Shock", "Thunderbolt", "Thunder Wave", "Thunder", "Rock Throw", "Earthquake",
 "Fissure", "Dig", "Toxic", "Confusion", "Psychic", "Hypnosis", "Meditate", "Agility", "Quick Attack", "Rage",
 "Teleport", "Night Shade", "Mimic", "Screech", "Double Team", "Recover", "Harden", "Minimize", "Smokescreen",
 "Confuse Ray", "Withdraw", "Defense Curl", "Barrier", "Light Screen", "Haze", "Reflect", "Focus Energy", "Bide",
 "Metronome", "Mirror Move", "Self-Destruct", "Egg Bomb", "Lick", "Smog", "Sludge", "Bone Club", "Fire Blast",
 "Waterfall", "Clamp", "Swift", "Skull Bash", "Spike Cannon", "Constrict", "Amnesia", "Kinesis", "Soft-Boiled",
 "High Jump Kick", "Glare", "Dream Eater", "Poison Gas", "Barrage", "Leech Life", "Lovely Kiss", "Sky Attack",
 "Transform", "Bubble", "Dizzy Punch", "Spore", "Flash", "Psywave", "Splash", "Acid Armor", "Crabhammer",
 "Explosion", "Fury Swipes", "Bonemerang", "Rest", "Rock Slide", "Hyper Fang", "Sharpen", "Conversion", "Tri Attack",
 "Super Fang", "Slash", "Substitute", "Struggle", "Sketch", "Triple Kick", "Thief", "Spider Web", "Mind Reader",
 "Nightmare", "Flame Wheel", "Snore", "Curse", "Flail", "Conversion 2", "Aeroblast", "Cotton Spore", "Reversal",
 "Spite", "Powder Snow", "Protect", "Mach Punch", "Scary Face", "Feint Attack", "Sweet Kiss", "Belly Drum",
 "Sludge Bomb", "Mud-Slap", "Octazooka", "Spikes", "Zap Cannon", "Foresight", "Destiny Bond", "Perish Song",
 "Icy Wind", "Detect", "Bone Rush", "Lock-On", "Outrage", "Sandstorm", "Giga Drain", "Endure", "Charm", "Rollout",
 "False Swipe", "Swagger", "Milk Drink", "Spark", "Fury Cutter", "Steel Wing", "Mean Look", "Attract", "Sleep Talk",
 "Heal Bell", "Return", "Present", "Frustration", "Safeguard", "Pain Split", "Sacred Fire", "Magnitude",
 "Dynamic Punch", "Megahorn", "Dragon Breath", "Baton Pass", "Encore", "Pursuit", "Rapid Spin", "Sweet Scent",
 "Iron Tail", "Metal Claw", "Vital Throw", "Morning Sun", "Synthesis", "Moonlight", "Hidden Power", "Cross Chop",
 "Twister", "Rain Dance", "Sunny Day", "Crunch", "Mirror Coat", "Psych Up", "Extreme Speed", "Ancient Power",
 "Shadow Ball", "Future Sight", "Rock Smash", "Whirlpool", "Beat Up", "Fake Out", "Uproar", "Stockpile", "Spit Up",
 "Swallow", "Heat Wave", "Hail", "Torment", "Flatter", "Will-O-Wisp", "Memento", "Facade", "Focus Punch",
 "Smelling Salts", "Follow Me", "Nature Power", "Charge", "Taunt", "Helping Hand", "Trick", "Role Play", "Wish",
 "Assist", "Ingrain", "Superpower", "Magic Coat", "Recycle", "Revenge", "Brick Break", "Yawn", "Knock Off", "Endeavor",
 "Eruption", "Skill Swap", "Imprison", "Refresh", "Grudge", "Snatch", "Secret Power", "Dive", "Arm Thrust", "Camouflage",
 "Tail Glow", "Luster Purge", "Mist Ball", "Feather Dance", "Teeter Dance", "Blaze Kick", "Mud Sport", "Ice Ball",
 "Needle Arm", "Slack Off", "Hyper Voice", "Poison Fang", "Crush Claw", "Blast Burn", "Hydro Cannon", "Meteor Mash",
 "Astonish", "Weather Ball", "Aromatherapy", "Fake Tears", "Air Cutter", "Overheat", "Odor Sleuth", "Rock Tomb",
 "Silver Wind", "Metal Sound", "Grass Whistle", "Tickle", "Cosmic Power", "Water Spout", "Signal Beam", "Shadow Punch",
 "Extrasensory", "Sky Uppercut", "Sand Tomb", "Sheer Cold", "Muddy Water", "Bullet Seed", "Aerial Ace", "Icicle Spear",
 "Iron Defense", "Block", "Howl", "Dragon Claw", "Frenzy Plant", "Bulk Up", "Bounce", "Mud Shot", "Poison Tail", "Covet",
 "Volt Tackle", "Magical Leaf", "Water Sport", "Calm Mind", "Leaf Blade", "Dragon Dance", "Rock Blast", "Shock Wave",
 "Water Pulse", "Doom Desire", "Psycho Boost"}

local nationalDexList = {
 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74,
 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99,
 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179,
 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199,
 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219,
 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 387, 388, 389, 390, 391, 392, 393, 394,
 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 252, 253, 254,
 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274,
 275, 290, 291, 292, 276, 277, 285, 286, 327, 278, 279, 283, 284, 320, 321, 300, 301, 352, 343, 344,
 299, 324, 302, 339, 340, 370, 341, 342, 349, 350, 318, 319, 328, 329, 330, 296, 297, 309, 310, 322,
 323, 363, 364, 365, 331, 332, 361, 362, 337, 338, 298, 325, 326, 311, 312, 303, 307, 308, 333, 334,
 360, 355, 356, 315, 287, 288, 289, 316, 317, 357, 293, 294, 295, 366, 367, 368, 359, 353, 354, 336,
 335, 369, 304, 305, 306, 351, 313, 314, 345, 346, 347, 348, 280, 281, 282, 371, 372, 373, 374, 375,
 376, 377, 378, 379, 382, 383, 384, 380, 381, 385, 386, 358}

local pokemonAbilities = {
 [001] = {65, 34}, [002] = {65, 34}, [003] = {65, 34}, [004] = {66}, [005] = {66}, [006] = {66}, [007] = {67, 44},
 [008] = {67, 44}, [009] = {67, 44}, [010] = {19, 50}, [011] = {61}, [012] = {14}, [013] = {19, 50}, [014] = {61},
 [015] = {68}, [016] = {51}, [017] = {51}, [018] = {51}, [019] = {50, 62, 55}, [020] = {50, 62, 55}, [021] = {51},
 [022] = {51}, [023] = {22, 61}, [024] = {22, 61}, [025] = {9, 31}, [026] = {9, 31}, [027] = {8}, [028] = {8},
 [029] = {38, 55}, [030] = {38, 55}, [031] = {38}, [032] = {38, 55}, [033] = {38, 55}, [034] = {38}, [035] = {56},
 [036] = {56}, [037] = {18, 70}, [038] = {18, 70}, [039] = {56}, [040] = {56}, [041] = {39}, [042] = {39},
 [043] = {34, 50}, [044] = {34, 1}, [045] = {34, 27}, [046] = {27, 6}, [047] = {27, 6}, [048] = {14, 50},
 [049] = {19}, [050] = {8, 71}, [051] = {8, 71}, [052] = {53}, [053] = {7}, [054] = {6, 13, 33},
 [055] = {6, 13, 33}, [056] = {72}, [057] = {72}, [058] = {22, 18}, [059] = {22, 18}, [060] = {11, 6, 33},
 [061] = {11, 6, 33}, [062] = {11, 6, 33}, [063] = {28, 39}, [064] = {28, 39}, [065] = {28, 39}, [066] = {62},
 [067] = {62}, [068] = {62}, [069] = {34}, [070] = {34}, [071] = {34}, [072] = {29, 64, 44}, [073] = {29, 64, 44},
 [074] = {69, 5, 8}, [075] = {69, 5, 8}, [076] = {69, 5, 8}, [077] = {50, 18, 49}, [078] = {50, 18, 49},
 [079] = {12, 20}, [080] = {12, 20}, [081] = {42, 5}, [082] = {42, 5}, [083] = {51, 39}, [084] = {50, 48},
 [085] = {50, 48}, [086] = {47}, [087] = {47}, [088] = {1, 60}, [089] = {1, 60}, [090] = {75}, [091] = {75},
 [092] = {26}, [093] = {26}, [094] = {26}, [095] = {69, 5}, [096] = {15, 39}, [097] = {15, 39}, [098] = {52, 75},
 [099] = {52, 75}, [100] = {43, 9}, [101] = {43, 9}, [102] = {34}, [103] = {34}, [104] = {69, 31, 4},
 [105] = {69, 31, 4}, [106] = {7}, [107] = {51, 39}, [108] = {20, 12, 13}, [109] = {26, 1}, [110] = {26, 1},
 [111] = {31, 69}, [112] = {31, 69}, [113] = {30, 32}, [114] = {34}, [115] = {48, 39}, [116] = {33, 6},
 [117] = {38, 6}, [230] = {33, 6}, [118] = {33, 41, 31}, [119] = {33, 41, 31}, [120] = {35, 30}, [121] = {35, 30},
 [122] = {43}, [123] = {68}, [212] = {68}, [238] = {12}, [124] = {12}, [239] = {9, 72}, [125] = {9, 72},
 [240] = {49, 72}, [126] = {49, 72}, [127] = {52}, [128] = {22}, [129] = {33}, [130] = {22}, [131] = {11, 75},
 [132] = {7}, [133] = {50}, [134] = {11}, [135] = {10}, [136] = {18, 62}, [196] = {28}, [197] = {28, 39},
 [137] = {36}, [233] = {36}, [138] = {33, 75}, [139] = {33, 75}, [140] = {33, 4}, [141] = {33, 4}, [142] = {69, 46},
 [143] = {17, 47}, [144] = {46}, [145] = {46, 9}, [146] = {46, 49}, [147] = {61, 63}, [148] = {61, 63}, [149] = {39},
 [150] = {46}, [151] = {28}, [152] = {65}, [153] = {65}, [154] = {65}, [155] = {66, 18}, [156] = {66, 18},
 [157] = {66, 18}, [158] = {67}, [159] = {67}, [160] = {67}, [161] = {50, 51}, [162] = {50, 51}, [163] = {15, 51},
 [164] = {15, 51}, [165] = {68, 48}, [166] = {68, 48}, [167] = {68, 15}, [168] = {68, 15}, [169] = {39},
 [170] = {10, 35, 11}, [171] = {10, 35, 11}, [172] = {9, 31}, [173] = {56}, [174] = {56}, [175] = {55, 32},
 [176] = {55, 32}, [177] = {28, 48}, [178] = {28, 48}, [179] = {9, 57}, [180] = {9, 57}, [181] = {9, 57}, [182] = {34},
 [183] = {47, 37}, [184] = {47, 37}, [185] = {5, 69}, [186] = {11, 6, 2}, [187] = {34}, [188] = {34}, [189] = {34},
 [190] = {50, 53}, [191] = {34, 48}, [192] = {34, 48}, [193] = {3, 14}, [194] = {6, 11}, [195] = {6, 11}, [198] = {15},
 [199] = {12, 20}, [200] = {26}, [201] = {26}, [202] = {23}, [203] = {39, 48}, [204] = {5}, [205] = {5},
 [206] = {32, 50}, [207] = {52, 8, 17}, [208] = {69, 5}, [209] = {22, 50}, [210] = {22}, [211] = {38, 33, 22},
 [213] = {5}, [214] = {68, 62}, [215] = {39, 51}, [216] = {53}, [217] = {62}, [218] = {40, 49}, [219] = {40, 49},
 [220] = {12, 47}, [221] = {12, 47}, [222] = {55, 30}, [223] = {55}, [224] = {21}, [225] = {72, 55, 15},
 [226] = {33, 11, 41}, [227] = {51, 5}, [228] = {48, 18}, [229] = {48, 18}, [231] = {53, 8}, [232] = {5, 8},
 [234] = {22}, [235] = {20}, [236] = {62, 72}, [237] = {22}, [241] = {47}, [242] = {30, 32}, [243] = {46, 39},
 [244] = {46, 39}, [245] = {46, 39}, [246] = {62, 8}, [247] = {61}, [248] = {45}, [249] = {46}, [250] = {46},
 [251] = {30}, [252] = {65}, [253] = {65}, [254] = {65}, [255] = {66, 3}, [256] = {66, 3}, [257] = {66, 3},
 [258] = {67, 6}, [259] = {67, 6}, [260] = {67, 6}, [261] = {50}, [262] = {22}, [263] = {53}, [264] = {53},
 [265] = {19, 50}, [266] = {61}, [267] = {68}, [268] = {61}, [269] = {19, 14}, [270] = {33, 44, 20}, [271] = {33, 44, 20},
 [272] = {33, 44, 20}, [273] = {34, 48}, [274] = {34, 48}, [275] = {34, 48}, [276] = {62}, [277] = {62}, [278] = {51, 44},
 [279] = {51, 2, 44}, [280] = {28, 36}, [281] = {28, 36}, [282] = {28, 36}, [283] = {33, 44}, [284] = {22}, [285] = {27},
 [286] = {27}, [287] = {54}, [288] = {72}, [289] = {54}, [290] = {14, 50}, [291] = {3}, [292] = {25}, [293] = {43},
 [294] = {43}, [295] = {43}, [296] = {47, 62}, [297] = {47, 62}, [298] = {47, 37}, [299] = {5, 42}, [300] = {56},
 [301] = {56}, [302] = {51}, [303] = {52, 22}, [304] = {5, 69}, [305] = {5, 69}, [306] = {5, 69}, [307] = {74},
 [308] = {74}, [309] = {9, 31, 58}, [310] = {9, 31, 58}, [311] = {57, 31}, [312] = {58, 10}, [313] = {35, 68},
 [314] = {12}, [315] = {30, 38}, [316] = {64, 60}, [317] = {64, 60}, [318] = {24, 3}, [319] = {24, 3},
 [320] = {41, 12, 46}, [321] = {41, 12, 46}, [322] = {12, 20}, [323] = {40}, [324] = {73, 70, 75}, [325] = {47, 20},
 [326] = {47, 20}, [327] = {20}, [328] = {52, 71}, [329] = {26}, [330] = {26}, [331] = {8, 11}, [332] = {8, 11},
 [333] = {30, 13}, [334] = {30, 13}, [335] = {17}, [336] = {61}, [337] = {26}, [338] = {26}, [339] = {12}, [340] = {12},
 [341] = {52, 75}, [342] = {52, 75}, [343] = {26}, [344] = {26}, [345] = {21}, [346] = {21}, [347] = {4, 33},
 [348] = {4, 33}, [349] = {33, 12}, [350] = {63, 56}, [351] = {59}, [352] = {16}, [353] = {15}, [354] = {15},
 [355] = {26}, [356] = {46}, [357] = {34}, [358] = {26}, [359] = {46}, [360] = {23}, [361] = {39}, [362] = {39},
 [363] = {47, 12}, [364] = {47, 12}, [365] = {47, 12}, [366] = {75}, [367] = {33, 41}, [368] = {33}, [369] = {33, 69, 5},
 [370] = {33}, [371] = {69}, [372] = {69}, [373] = {22}, [374] = {29}, [375] = {29}, [376] = {29}, [377] = {29, 5},
 [378] = {29}, [379] = {29}, [380] = {26}, [381] = {26}, [382] = {2}, [383] = {70}, [384] = {77}, [385] = {32}, [386] = {46}}

local itemNamesList = {
 "None", "Master Ball", "Ultra Ball", "Great Ball", "Poke Ball", "Safari Ball", "Net Ball", "Dive Ball", "Nest Ball",
 "Repeat Ball", "Timer Ball", "Luxury Ball", "Premier Ball", "Potion", "Antidote", "Burn Heal", "Ice Heal", "Awakening",
 "Parlyz Heal", "Full Restore", "Max Potion", "Hyper Potion", "Super Potion", "Full Heal", "Revive", "Max Revive",
 "Fresh Water", "Soda Pop", "Lemonade", "Moomoo Milk", "EnergyPowder", "Energy Root", "Heal Powder", "Revival Herb",
 "Ether", "Max Ether", "Elixir", "Max Elixir", "Lava Cookie", "Blue Flute", "Yellow Flute", "Red Flute", "Black Flute",
 "White Flute", "Berry Juice", "Sacred Ash", "Shoal Salt", "Shoal Shell", "Red Shard", "Blue Shard", "Yellow Shard",
 "Green Shard", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown",
 "unknown", "unknown", "HP Up", "Protein", "Iron", "Carbos", "Calcium", "Rare Candy", "PP Up", "Zinc", "PP Max",
 "unknown", "Guard Spec.", "Dire Hit", "X Attack", "X Defend", "X Speed", "X Accuracy", "X Special", "Poke Doll",
 "Fluffy Tail", "unknown", "Super Repel", "Max Repel", "Escape Rope", "Repel", "unknown", "unknown", "unknown",
 "unknown", "unknown", "unknown", "Sun Stone", "Moon Stone", "Fire Stone", "Thunderstone", "Water Stone", "Leaf Stone",
 "unknown", "unknown", "unknown", "unknown", "TinyMushroom", "Big Mushroom", "unknown", "Pearl", "Big Pearl", "Stardust",
 "Star Piece", "Nugget", "Heart Scale", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown",
 "unknown", "unknown", "Orange Mail", "Harbor Mail", "Glitter Mail", "Mech Mail", "Wood Mail", "Wave Mail", "Bead Mail",
 "Shadow Mail", "Tropic Mail", "Dream Mail", "Fab Mail", "Retro Mail", "Cheri Berry", "Chesto Berry", "Pecha Berry",
 "Rawst Berry", "Aspear Berry", "Leppa Berry", "Oran Berry", "Persim Berry", "Lum Berry", "Sitrus Berry", "Figy Berry",
 "Wiki Berry", "Mago Berry", "Aguav Berry", "Iapapa Berry", "Razz Berry", "Bluk Berry", "Nanab Berry", "Wepear Berry",
 "Pinap Berry", "Pomeg Berry", "Kelpsy Berry", "Qualot Berry", "Hondew Berry", "Grepa Berry", "Tamato Berry",
 "Cornn Berry", "Magost Berry", "Rabuta Berry", "Nomel Berry", "Spelon Berry", "Pamtre Berry", "Watmel Berry",
 "Durin Berry", "Belue Berry", "Liechi Berry", "Ganlon Berry", "Salac Berry", "Petaya Berry", "Apicot Berry",
 "Lansat Berry", "Starf Berry", "Enigma Berry", "unknown", "unknown", "unknown", "BrightPowder", "White Herb",
 "Macho Brace", "Exp. Share", "Quick Claw", "Soothe Bell", "Mental Herb", "Choice Band", "King's Rock", "SilverPowder",
 "Amulet Coin", "Cleanse Tag", "Soul Dew", "DeepSeaTooth", "DeepSeaScale", "Smoke Ball", "Everstone", "Focus Band",
 "Lucky Egg", "Scope Lens", "Metal Coat", "Leftovers", "Dragon Scale", "Light Ball", "Soft Sand", "Hard Stone",
 "Miracle Seed", "BlackGlasses", "Black Belt", "Magnet", "Mystic Water", "Sharp Beak", "Poison Barb", "NeverMeltIce",
 "Spell Tag", "TwistedSpoon", "Charcoal", "Dragon Fang", "Silk Scarf", "Up-Grade", "Shell Bell", "Sea Incense",
 "Lax Incense", "Lucky Punch", "Metal Powder", "Thick Club", "Stick", "unknown", "unknown", "unknown", "unknown",
 "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown",
 "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", "unknown",
 "unknown", "unknown", "Red Scarf", "Blue Scarf", "Pink Scarf", "Green Scarf", "Yellow Scarf", "Mach Bike", "Coin Case",
 "Itemfinder", "Old Rod", "Good Rod", "Super Rod", "S.S. Ticket", "Contest Pass", "unknown", "Wailmer Pail", "Devon Goods",
 "Soot Sack", "Basement Key", "Acro Bike", "Pokeblock Case", "Letter", "Eon Ticket", "Red Orb", "Blue Orb", "Scanner",
 "Go-Goggles", "Meteorite", "Rm. 1 Key", "Rm. 2 Key", "Rm. 4 Key", "Rm. 6 Key", "Storage Key", "Root Fossil", "Claw Fossil",
 "Devon Scope", "TM 01", "TM 02", "TM 03", "TM 04", "TM 05", "TM 06", "TM 07", "TM 08", "TM 09", "TM 10", "TM 11", "TM 12",
 "TM 13", "TM 14", "TM 15", "TM 16", "TM 17", "TM 18", "TM 19", "TM 20", "TM 21", "TM 22", "TM 23", "TM 24", "TM 25",
 "TM 26", "TM 27", "TM 28", "TM 29", "TM 30", "TM 31", "TM 32", "TM 33", "TM 34", "TM 35", "TM 36", "TM 37", "TM 38", "TM 39",
 "TM 40", "TM 41", "TM 42", "TM 43", "TM 44", "TM 45", "TM 46", "TM 47", "TM 48", "TM 49", "TM 50", "HM 01", "HM 02", "HM 03",
 "HM 04", "HM 05", "HM 06", "HM 07", "HM 08", "unknown", "unknown", "Oak's Parcel", "Poke Flute", "Secret Key", "Bike Voucher",
 "Gold Teeth", "Old Amber", "Card Key", "Lift Key", "Helix Fossil", "Dome Fossil", "Silph Scope", "Bicycle", "Town Map",
 "VS Seeker", "Fame Checker", "TM Case", "Berry Pouch", "Teachy TV", "Tri-Pass", "Rainbow Pass", "Tea", "MysticTicket",
 "AuroraTicket", "Powder Jar", "Ruby", "Sapphire", "Magma Emblem", "Old Sea Map"}

local catchRatesList = {
 -- Gen 1
 45, 45, 45, 45, 45, 45, 45, 45, 45, 255, 120, 45, 255, 120, 45, 255, 120, 45, 255, 127, 255, 90, 255,
 90, 190, 75, 255, 90, 235, 120, 45, 235, 120, 45, 150, 25, 190, 75, 170, 50, 255, 90, 255, 120, 45,
 190, 75, 190, 75, 255, 50, 255, 90, 190, 75, 190, 75, 190, 75, 255, 120, 45, 200, 100, 50, 180, 90,
 45, 255, 120, 45, 190, 60, 255, 120, 45, 190, 60, 190, 75, 190, 60, 45, 190, 45, 190, 75, 190, 75,
 190, 60, 190, 90, 45, 45, 190, 75, 225, 60, 190, 60, 90, 45, 190, 75, 45, 45, 45, 190, 60, 120, 60,
 30, 45, 45, 225, 75, 225, 60, 225, 60, 45, 45, 45, 45, 45, 45, 45, 255, 45, 45, 35, 45, 45, 45, 45,
 45, 45, 45, 45, 45, 45, 25, 3, 3, 3, 45, 45, 45, 3, 45,
 -- Gen 2
 45, 45, 45, 45, 45, 45, 45, 45, 45, 255, 90, 255, 90, 255, 90, 255, 90, 90, 190, 75, 190, 150, 170,
 190, 75, 190, 75, 235, 120, 45, 45, 190, 75, 65, 45, 255, 120, 45, 45, 235, 120, 75, 255, 90, 45, 45,
 30, 70, 45, 225, 45, 60, 190, 75, 190, 60, 25, 190, 75, 45, 25, 190, 45, 60, 120, 60, 190, 75, 225,
 75, 60, 190, 75, 45, 25, 25, 120, 45, 45, 120, 60, 45, 45, 45, 75, 45, 45, 45, 45, 45, 30, 3, 3, 3, 45,
 45, 45, 3, 3, 45,
 -- Gen 3
 45, 45, 45, 45, 45, 45, 45, 45, 45, 255, 127, 255, 90, 255, 120, 45, 120, 45, 255, 120, 45, 255, 120,
 45, 200, 45, 190, 45, 235, 120, 45, 200, 75, 255, 90, 255, 120, 45, 255, 120, 45, 190, 120, 45, 180,
 200, 150, 255, 255, 60, 45, 45, 180, 90, 45, 180, 90, 120, 45, 200, 200, 150, 150, 150, 225, 75, 225,
 60, 125, 60, 255, 150, 90, 255, 60, 255, 255, 120, 45, 190, 60, 255, 45, 90, 90, 45, 45, 190, 75, 205,
 155, 255, 90, 45, 45, 45, 45, 255, 60, 45, 200, 225, 45, 190, 90, 200, 45, 30, 125, 190, 75, 255, 120,
 45, 255, 60, 60, 25, 225, 45, 45, 45, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 3, 3, 3}

local locationNamesList = {
 "Petalburg City", "Slateport City", "Mauville City", "Rustboro City", "Fortree City", "Lilycove City",
 "Mossdeep City", "Sootopolis City", "Ever Grande City", "Littleroot Town", "Oldale Town", "Dewford Town",
 "Lavaridge Town", "Fallarbor Town", "Verdanturf Town", "Pacifidlog Town", "Route 101", "Route 102",
 "Route 103", "Route 104", "Route 105", "Route 106", "Route 107", "Route 108", "Route 109", "Route 110",
 "Route 111", "Route 112", "Route 113", "Route 114", "Route 115", "Route 116", "Route 117", "Route 118",
 "Route 119", "Route 120", "Route 121", "Route 122", "Route 123", "Route 124", "Route 125", "Route 126",
 "Route 127", "Route 128", "Route 129", "Route 130", "Route 131", "Route 132", "Route 133", "Route 134",
 "Underwater 1", "Underwater 2", "Underwater 3", "Underwater 4"}

local statusConditionNamesList = {"None", "SLP", "PSN", "BRN", "FRZ", "PAR", "PSN"}

client.reboot_core()

local gameCode = read32Bit(0x0000AC, "ROM")
local gameVersionCode = band(gameCode, 0xFFFFFF)
local gameLanguageCode = rshift(gameCode, 24)
local gameVersion = ""
local gameLanguage = ""
local wrongGameVersion = true

local mode = {"None", "Capture", "100% Catch", "Breeding", "Pandora", "Pokemon Info"}
local index = 1
local prevKey = {}
local showRngInfoText = true
local showRoamerInfoText = false
local showInstructionsText = false

local safariCatchFactorAddr = 0x02016089
local catchCheckFlagAddr = 0x02017810
local pokemonStatsScreenAddr = 0x02018010
local partySelectedSlotIndexAddr = 0x020200BA
local speciesDexIndexAddr
local wildTypeAddr
local saveBlock2Addr
local saveBlock1Addr
local eggLowPIDAddr
local mapTypeAddr
local currBoxIndexAddr
local boxSelectedSlotIndexAddr
local selectedItemAddr
local safariZoneStepsCounterAddr
local roamerMapGroupAndNumAddr
local timerAddr
local battleTurnsCounterAddr
local partySlotsCounterAddr
local partyAddr
local wildAddr
local currentSeedAddr

local initialSeed = 0
local advances = 0
local tempCurrentSeed = 0

local ballRate = {"10", "2550", "20", "15", "10", "15", "10", "10", "10", "10", "10", "10", "10"}
local startingCatchAdvances
local catchDelayCounter = 999
local catchDelay = 0
local catchRngStop = true
local catchSkips
local oneTimeCatchRng = true
local currentSeed2 = nil

local infoMode = {"Gift", "Party", "Stats", "Box"}
local infoIndex = 1
local prevKeyInfo = {}

if gameVersionCode == 0x505841 then  -- Check game version
 gameVersion = "Sapphire"
elseif gameVersionCode == 0x565841 then
 gameVersion = "Ruby"
elseif gameVersionCode == 0x455042 then
 gameVersion = "Emerald"
elseif gameVersionCode == 0x475042 then
 gameVersion = "LeafGreen"
elseif gameVersionCode == 0x525042 then
 gameVersion = "FireRed"
end

if gameLanguageCode == 0x45 then
 gameLanguage = "USA"
 speciesDexIndexAddr = 0x02024464
 wildTypeAddr = 0x02024AF9
 saveBlock2Addr = 0x02024EA4
 saveBlock1Addr = 0x02025734
 eggLowPIDAddr = 0x020287E8
 mapTypeAddr = 0x0202E83F
 currBoxIndexAddr = 0x020300A0
 boxSelectedSlotIndexAddr = 0x020384E5
 selectedItemAddr = 0x0203855E
 safariZoneStepsCounterAddr = 0x0203880A
 roamerMapGroupAndNumAddr = 0x02039302
 timerAddr = 0x03001790
 battleTurnsCounterAddr = 0x030042F3
 partySlotsCounterAddr = 0x03004350
 partyAddr = 0x03004360
 wildAddr = 0x030045C0
 currentSeedAddr = 0x03004818
elseif gameLanguageCode == 0x4A then  -- Check game language and set addresses
 gameLanguage = "JPN"
 speciesDexIndexAddr = 0x020241C4
 wildTypeAddr = 0x02024859
 saveBlock2Addr = 0x02024C04
 saveBlock1Addr = 0x02025494
 eggLowPIDAddr = 0x02028548
 mapTypeAddr = 0x0202E59F
 currBoxIndexAddr = 0x0202FDBC
 boxSelectedSlotIndexAddr = 0x02038201
 selectedItemAddr = 0x0203825C
 safariZoneStepsCounterAddr = 0x02038506
 roamerMapGroupAndNumAddr = 0x02038FFA
 timerAddr = 0x03001700
 battleTurnsCounterAddr = 0x03004223
 partySlotsCounterAddr = 0x03004280
 partyAddr = 0x03004290
 wildAddr = 0x030044F0
 currentSeedAddr = 0x03004748
elseif gameLanguageCode == 0x44 or gameLanguageCode == 0x46 or gameLanguageCode == 0x49 or gameLanguageCode == 0x53 then
 gameLanguage = "EUR"
 speciesDexIndexAddr = 0x02024464
 wildTypeAddr = 0x02024AF9
 saveBlock2Addr = 0x02024EA4
 saveBlock1Addr = 0x02025734
 eggLowPIDAddr = 0x020287E8
 mapTypeAddr = 0x0202E83F
 currBoxIndexAddr = 0x020300A0
 boxSelectedSlotIndexAddr = 0x020384E5
 selectedItemAddr = 0x0203855E
 safariZoneStepsCounterAddr = 0x0203880A
 roamerMapGroupAndNumAddr = 0x02039302
 timerAddr = 0x03001790
 battleTurnsCounterAddr = 0x03004303
 partySlotsCounterAddr = 0x03004360
 partyAddr = 0x03004370
 wildAddr = 0x030045D0
 currentSeedAddr = 0x03004828
end

console.clear()

if gameVersion == "" then  -- Print game info
 print("Version: Unknown game")
elseif gameVersion ~= "Ruby" and gameVersion ~= "Sapphire" then
 print("Version: "..gameVersion.." - Wrong game version! Use Ruby/Sapphire instead")
elseif gameLanguage == "" then
 print("Version: "..gameVersion)
 print("Language: Unknown language")
else
 wrongGameVersion = false
 print("Version: "..gameVersion)
 print("Language: "..gameLanguage)
end

function setBackgroundBoxes()  -- Set transparent black boxes
 gui.defaultTextBackground("clear")
 gui.defaultPixelFont("gens")

 if mode[index] == "None" or mode[index] == "100% Catch" or mode[index] == "Pandora" then
  gui.drawBox(0, 0, 112, 7, 0x7F000000, 0x7F000000)
 elseif mode[index] == "Capture" or mode[index] == "Breeding" or mode[index] == "Pokemon Info" then
  gui.drawBox(0, 0, 112, 91, 0x7F000000, 0x7F000000)
 end

 if mode[index] ~= "None" and mode[index] ~= "100% Catch" then
  gui.drawBox(199, 145, 239, 159, 0x7F000000, 0x7F000000)
 end
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

function getInput()
 local leftArrowColor = "gray"
 local rightArrowColor = "gray"

 local key = input.get()

 if (key["Number1"] or key["Keypad1"]) and (not prevKey["Number1"] and not prevKey["Keypad1"]) then
  leftArrowColor = "orange"
  index = index - 1 < 1 and 6 or index - 1
 elseif (key["Number2"] or key["Keypad2"]) and (not prevKey["Number2"] and not prevKey["Keypad2"]) then
  rightArrowColor = "orange"
  index = index + 1 > 6 and 1 or index + 1
 end

 prevKey = key
 gui.pixelText(0, 0, "Mode: "..mode[index])
 drawArrowLeft(75, 0, leftArrowColor)
 gui.pixelText(83, 0, "1 - 2")
 drawArrowRight(111, 0, rightArrowColor)
end

function LCRNG(s, mul1, mul2, sum)
 local a = mul1 * (s % 0x10000) + rshift(s, 16) * mul2
 local b = mul2 * (s % 0x10000) + (a % 0x10000) * 0x10000 + sum
 local c = b % 0x100000000

 return c
end

function calcAdvancesJump(seed)
 local advancesJump = 0

 if tempCurrentSeed ~= seed then
  local tempCurrentSeed2 = tempCurrentSeed

  while tempCurrentSeed ~= seed and tempCurrentSeed2 ~= seed do
   tempCurrentSeed = LCRNG(tempCurrentSeed, 0x41C6, 0x4E6D, 0x6073)  -- LCRNG next
   tempCurrentSeed2 = LCRNG(tempCurrentSeed2, 0xEEB9, 0xEB65, 0x0A3561A1)  -- LCRNG back
   advancesJump = advancesJump + 1
  end

  if tempCurrentSeed2 == seed then
   advancesJump = (-1) * advancesJump
   tempCurrentSeed = tempCurrentSeed2
  end
 end

 userdata.set("temp", tempCurrentSeed)

 return advancesJump
end

function getRngInfo()
 local current = read32Bit(currentSeedAddr)
 local painting = read16Bit(timerAddr)

 if (painting == 0 and current <= 0xFFFF) or current == painting then
  initialSeed = current
  tempCurrentSeed = current
 end

 advances = initialSeed == current and 0 or advances + calcAdvancesJump(current)

 userdata.set("seed", initialSeed)
 userdata.set("advances", advances)

 return painting, current, advances
end

function showRngInfo()
 local paintingSeed, currentSeed, currentAdvances = getRngInfo()

 if showRngInfoText and mode[index] ~= "None" and mode[index] ~= "100% Catch" then
  gui.drawBox(0, 131, 96, 159, 0x7F000000, 0x7F000000)
  gui.pixelText(-1, 131, string.format("Initial Seed: %04X", initialSeed))
  gui.pixelText(0, 138, string.format("Painting Timer: %08X", paintingSeed))
  gui.pixelText(0, 145, string.format("Current Seed: %08X", currentSeed))
  gui.pixelText(0, 152, "Advances: "..currentAdvances)
 end
end

function getRngInfoInput()
 local key = input.get()

 if key["Number5"] or key["Keypad5"] then
  showRngInfoText = true
 elseif key["Number6"] or key["Keypad6"] then
  showRngInfoText = false
 end

 if (mode[index] == "Capture" or mode[index] == "Breeding" or mode[index] == "Pandora" or mode[index] == "Pokemon Info")
     and showRngInfoText
 then
  gui.drawBox(98, 152, 166, 159, 0x7F000000, 0x7F000000)
  gui.pixelText(98, 152, "6 - Hide RNG info")
 elseif (mode[index] == "Capture" or mode[index] == "Breeding" or mode[index] == "Pandora" or mode[index] == "Pokemon Info")
         and not showRngInfoText
 then
  gui.drawBox(98, 152, 166, 159, 0x7F000000, 0x7F000000)
  gui.pixelText(98, 152, "5 - Show RNG info")
 end
end

function getTrainerIDs()
 local trainerIDsAddr = saveBlock2Addr + 0xA
 local trainerIDs = read32Bit(trainerIDsAddr)
 local TID = band(trainerIDs, 0xFFFF)
 local SID = rshift(trainerIDs, 16)

 return TID, SID
end

function showTrainerIDs()
 local trainerTID, trainerSID = getTrainerIDs()

 gui.pixelText(199, 145, string.format("TID: %d", trainerTID))
 gui.pixelText(199, 152, string.format("SID: %d", trainerSID))
end

function getInstructionsInput()
 local key = input.get()

 if mode[index] == "100% Catch" then
  if key["Number3"] or key["Keypad3"] then
   showInstructionsText = true
  elseif key["Number4"] or key["Keypad4"] then
   showInstructionsText = false
  end
 end

 gui.drawBox(159, 0, 239, 7, 0x7F000000, 0x7F000000)

 if mode[index] == "100% Catch" and showInstructionsText then
  gui.pixelText(159, 0, "4 - Hide instructions")
  gui.drawBox(0, 9, 236, 93, 0x7F000000, 0x7F000000)
  gui.pixelText(0, 9, "1) During battle, go to BAG > POKE BALLS")
  gui.pixelText(0, 16, "2) Press A on the ball you want to use")
  gui.pixelText(0, 23, "3) Move the arrow on 'USE', pause the game and save a state")
  gui.pixelText(0, 30, "4) Advance a single frame (CTRL+N) while holding SELECT")
  gui.pixelText(0, 37, "and then unpause the game while holding A.")
  gui.pixelText(0, 44, "5) Wait until delay is calculated")
  gui.pixelText(0, 51, "6) Load the state you made, advance frames until counter")
  gui.pixelText(0, 58, "become 0")
  gui.pixelText(0, 65, "7) Unpase the game while holding A")
  gui.pixelText(0, 79, "Note: the delay can be not stable, be sure to check")
  gui.pixelText(0, 86, "counter -1 or +1")
 elseif not showInstructionsText then
  gui.pixelText(159, 0, "3 - Show instructions")
 else
  showInstructionsText = false
  catchRngStop = true
  catchDelayCounter = 999
  catchDelay = 0
 end
end

function getPokemonIDs(addr)
 local pokemonIDs = read32Bit(addr + 0x4)
 local TID = band(pokemonIDs, 0xFFFF)
 local SID = rshift(pokemonIDs, 16)

 return TID, SID
end

function shinyCheck(PID, addr)
 addr = addr or nil

 local trainerTID, trainerSID

 if mode[index] == "Pokemon Info" then
  trainerTID, trainerSID = getPokemonIDs(addr)
 else
  trainerTID, trainerSID = getTrainerIDs()
 end

 local highPID = rshift(PID, 16)
 local lowPID = band(PID, 0xFFFF)
 local shinyTypeValue = bxor(bxor(trainerSID, trainerTID), bxor(lowPID, highPID))

 if shinyTypeValue < 8 then
  return "limegreen", shinyTypeValue == 0 and " (Square)" or " (Star)"
 else  -- Not shiny
  return nil, ""
 end
end

function getOffset(offsetType, orderIndex)
 local offsets = {
  ["growth"] = {0,0,0,0,0,0, 1,1,2,3,2,3, 1,1,2,3,2,3, 1,1,2,3,2,3},
  ["attack"] = {1,1,2,3,2,3, 0,0,0,0,0,0, 2,3,1,1,3,2, 2,3,1,1,3,2},
  ["misc"] = {3,2,3,2,1,1, 3,2,3,2,1,1, 3,2,3,2,1,1, 0,0,0,0,0,0}}

 return offsets[offsetType][orderIndex] * 12
end

function getIVColor(value)
 if value >= 30 then
  return "limegreen"
 elseif value >= 1 and value <= 5 then
  return "orange"
 elseif value < 1 then
  return "red"
 else  -- IV value from 6 to 29
  return nil
 end
end

function getIVs(ivsValue)
 local hp = band(ivsValue, 0x1F)
 local atk = band(ivsValue, 0x1F * 0x20) / 0x20
 local def = band(ivsValue, 0x1F * 0x400) / 0x400
 local spAtk = band(ivsValue, 0x1F * 0x100000) / 0x100000
 local spDef = band(ivsValue, 0x1F * 0x2000000) / 0x2000000
 local spd = band(ivsValue, 0x1F * 0x8000) / 0x8000

 return hp, atk, def, spAtk, spDef, spd
end

function getHPTypeAndPower(hp, atk, def, spAtk, spDef, spd)
 local hpType = floor((((hp % 2) + (2 * (atk % 2)) + (4 * (def % 2)) + (8 * (spd % 2)) + (16 * (spAtk % 2))
                + (32 * (spDef % 2))) * 15) / 63)
 local hpPower = floor((((band(hp, 2) / 2 + band(atk, 2) + 2 * band(def, 2) + 4 * band(spd, 2) + 8 * band(spAtk, 2)
                 + 16 * band(spDef, 2)) * 40) / 63) + 30)

 return hpType, hpPower
end

function showIVsAndHP(ivsValue, isRoamer)
 local hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV = getIVs(ivsValue)
 local hpType, hpPower = getHPTypeAndPower(hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV)
 local textXOffset = isRoamer and 151 or 0

 gui.pixelText(-1 + textXOffset, 35, "IVs:")
 gui.pixelText(19 + textXOffset, 35, string.format("%02d", hpIV), getIVColor(hpIV))
 gui.pixelText(27 + textXOffset, 36, "/")
 gui.pixelText(31 + textXOffset, 35, string.format("%02d", atkIV), getIVColor(atkIV))
 gui.pixelText(39 + textXOffset, 36, "/")
 gui.pixelText(43 + textXOffset, 35, string.format("%02d", defIV), getIVColor(defIV))
 gui.pixelText(51 + textXOffset, 36, "/")
 gui.pixelText(55 + textXOffset, 35, string.format("%02d", spAtkIV), getIVColor(spAtkIV))
 gui.pixelText(63 + textXOffset, 36, "/")
 gui.pixelText(67 + textXOffset, 35, string.format("%02d", spDefIV), getIVColor(spDefIV))
 gui.pixelText(75 + textXOffset, 36, "/")
 gui.pixelText(79 + textXOffset, 35, string.format("%02d", spdIV), getIVColor(spdIV))

 gui.pixelText(0 + textXOffset, 42, "HPower: "..HPTypeNamesList[hpType + 1].." "..hpPower)
end

function getMoves(value1, value2)
 local move1 = band(value1, 0xFFF)
 local move2 = rshift(value1, 16)
 local move3 = band(value2, 0xFFF)
 local move4 = rshift(value2, 16)

 return move1, move2, move3, move4
end

function showMoves(value1, value2)
 local move1Index, move2Index, move3Index, move4Index = getMoves(value1, value2)

 gui.pixelText(0, 63, "Move: "..moveNamesList[move1Index <= 354 and move1Index + 1 or 1])
 gui.pixelText(0, 70, "Move: "..moveNamesList[move2Index <= 354 and move2Index + 1 or 1])
 gui.pixelText(0, 77, "Move: "..moveNamesList[move3Index <= 354 and move3Index + 1 or 1])
 gui.pixelText(0, 84, "Move: "..moveNamesList[move4Index <= 354 and move4Index + 1 or 1])
end

function getPPColor(value)
 if value >= 1 and value <= 4 then
  return "orange"
 elseif value < 1 then
  return "red"
 else  -- PP value higher than 4
  return nil
 end
end

function getPP(value)
 local PP1 = band(value, 0xFF)
 local PP2 = band(rshift(value, 8), 0xFF)
 local PP3 = band(rshift(value, 16), 0xFF)
 local PP4 = rshift(value, 24)

 return PP1, PP2, PP3, PP4
end

function showPP(value)
 local PPmove1, PPmove2, PPmove3, PPmove4 = getPP(value)

 gui.pixelText(88, 63, "PP:")
 gui.pixelText(104, 63, PPmove1, getPPColor(PPmove1))
 gui.pixelText(88, 70, "PP:")
 gui.pixelText(104, 70, PPmove2, getPPColor(PPmove2))
 gui.pixelText(88, 77, "PP:")
 gui.pixelText(104, 77, PPmove3, getPPColor(PPmove3))
 gui.pixelText(88, 84, "PP:")
 gui.pixelText(104, 84, PPmove4, getPPColor(PPmove4))
end

function showInfo(addr)
 local pokemonPID = read32Bit(addr)
 local shinyTypeTextColor, shinyType = shinyCheck(pokemonPID, addr)
 local natureIndex = pokemonPID % 25
 local pokemonIDs = read32Bit(addr + 0x4)
 local orderIndex = (pokemonPID % 24) + 1
 local decryptionKey = bxor(pokemonPID, pokemonIDs)
 local growthOffset = getOffset("growth", orderIndex)
 local attacksOffset = getOffset("attack", orderIndex)
 local miscOffset = getOffset("misc", orderIndex)

 local ivsAndAbilityValue = bxor(read32Bit(addr + 0x20 + miscOffset + 0x4), decryptionKey)
 local speciesAndItemValue = bxor(read32Bit(addr + 0x20 + growthOffset), decryptionKey)
 local movesValue1 = bxor(read32Bit(addr + 0x20 + attacksOffset), decryptionKey)
 local movesValue2 = bxor(read32Bit(addr + 0x20 + attacksOffset + 0x4), decryptionKey)
 local PPValue = bxor(read32Bit(addr + 0x20 + attacksOffset + 0x8), decryptionKey)

 local speciesDexIndex = band(speciesAndItemValue, 0xFFFF)
 local speciesDexNumber = nationalDexList[speciesDexIndex + 1]
 local speciesName = speciesNamesList[speciesDexNumber]

 local itemIndex = rshift(speciesAndItemValue, 16)
 local itemName = itemNamesList[itemIndex + 1]

 local abilityNumber = rshift(ivsAndAbilityValue, 0x1F) + 1
 local abilityName = abilityNamesList[pokemonAbilities[(speciesDexNumber ~= nil and speciesDexNumber < 387) and speciesDexNumber or 1]
                                                      [abilityNumber]]

 --[[if mode[index] == "Capture" then
  getEncounterMethod(pokemonPID, ivsAndAbilityValue)
 end]]

 gui.pixelText(0, 7, "Species: "..(speciesName ~= nil and speciesName or "--"))
 gui.pixelText(0, 14, "PID:")
 gui.pixelText(20, 14, string.format("%08X%s", pokemonPID, shinyType), shinyTypeTextColor)
 gui.pixelText(0, 21, "Nature: "..natureNamesList[natureIndex + 1])
 gui.pixelText(0, 28, string.format("Ability: %s (%d)", abilityName == nil and "--" or abilityName, abilityNumber))

 showIVsAndHP(ivsAndAbilityValue, false)

 gui.pixelText(0, 49, "Held item: "..(itemName ~= nil and itemName or "--"))

 showMoves(movesValue1, movesValue2)
 showPP(PPValue)
end

function getRoamerInput()
 local key = input.get()

 if key["Number3"] or key["Keypad3"] then
  showRoamerInfoText = true
 elseif key["Number4"] or key["Keypad4"] then
  showRoamerInfoText = false
 end

 if mode[index] == "Capture" and showRoamerInfoText then
  gui.drawBox(151, 0, 239, 84, 0x7F000000, 0x7F000000)
  gui.pixelText(159, 0, "4 - Hide roamer info")
 elseif mode[index] == "Capture" and not showRoamerInfoText then
  gui.drawBox(159, 0, 239, 7, 0x7F000000, 0x7F000000)
  gui.pixelText(159, 0, "3 - Show roamer info")
 end
end

function getRoamerInfo()
 local roamerAddr = saveBlock1Addr + 0x3144
 local roamerIVsValue = band(read32Bit(roamerAddr), 0xFF)
 local roamerPID = read32Bit(roamerAddr + 0x4)
 local roamerShinyTypeTextColor, roamerShinyType = shinyCheck(roamerPID)
 local roamerNatureIndex = roamerPID % 25
 local roamerSpeciesIndex = read16Bit(roamerAddr + 0x8)
 local roamerDexIndex = nationalDexList[roamerSpeciesIndex + 1]
 local roamerSpeciesName = speciesNamesList[roamerDexIndex]
 local roamerHP = read16Bit(roamerAddr + 0xA)
 local roamerLevel = read8Bit(roamerAddr + 0xC)
 local roamerStatusIndex = read8Bit(roamerAddr + 0xD)
 local roamerStatus = statusConditionNamesList[1]  -- No altered status condition

 local roamerMapGroupAndNum = read16Bit(roamerMapGroupAndNumAddr)
 local roamerMapIndex = rshift(roamerMapGroupAndNum, 8)
 local playerMapGroupAndNumAddr = saveBlock1Addr + 0x4
 local playerMapGroupAndNum = read16Bit(playerMapGroupAndNumAddr)

 if roamerStatusIndex > 0 and roamerStatusIndex < 0x8 then  -- Sleep
  roamerStatus = statusConditionNamesList[2]
 elseif roamerStatusIndex == 0x8 then  -- Poison
  roamerStatus = statusConditionNamesList[3]
 elseif roamerStatusIndex == 0x10 then  -- Burn
  roamerStatus = statusConditionNamesList[4]
 elseif roamerStatusIndex == 0x20 then  -- Freeze
  roamerStatus = statusConditionNamesList[5]
 elseif roamerStatusIndex == 0x40 then  -- Paralysis
  roamerStatus = statusConditionNamesList[6]
 elseif roamerStatusIndex == 0x80 then  -- Bad Poison
  roamerStatus = statusConditionNamesList[7]
 end

 local isRoamerActive = read8Bit(roamerAddr + 0x13) == 1

 return roamerSpeciesName, roamerPID, roamerShinyType, roamerShinyTypeTextColor, roamerNatureIndex, roamerIVsValue, isRoamerActive,
        roamerLevel, roamerHP, roamerStatus, roamerMapIndex, roamerMapGroupAndNum, playerMapGroupAndNum
end

function showRoamerInfo()
 local roamerSpeciesName, roamerPID, roamerShinyType, roamerShinyTypeTextColor, roamerNatureIndex, roamerIVsValue, isRoamerActive,
       roamerLevel, roamerHP, roamerStatus, roamerMapIndex, roamerMapGroupAndNum, playerMapGroupAndNum = getRoamerInfo()

 if isRoamerActive then
  gui.pixelText(151, 7, "Active Roamer? Yes")
  gui.pixelText(151, 14, "Species: "..roamerSpeciesName)
  gui.pixelText(151, 21, "PID:")
  gui.pixelText(171, 21, string.format("%08X%s", roamerPID, roamerShinyType), roamerShinyTypeTextColor)
  gui.pixelText(151, 28, "Nature: "..natureNamesList[roamerNatureIndex + 1])
  showIVsAndHP(roamerIVsValue, isRoamerActive)
  gui.pixelText(151, 49, "Level: "..roamerLevel)
  gui.pixelText(151, 56, "HP: "..roamerHP)
  gui.pixelText(151, 63, "Status condition: "..roamerStatus)
  gui.pixelText(151, 70, "Current position:")
  gui.pixelText(151, 77, locationNamesList[roamerMapIndex + 1], roamerMapGroupAndNum == playerMapGroupAndNum and "limegreen" or nil)
 else
  gui.pixelText(151, 7, "Active Roamer? No")
 end
end

function getCatchRngStopInput()
 local key = input.get()

 if key["Number5"] or key["Keypad5"] then
  catchRngStop = true
  catchDelayCounter = 999
  catchDelay = 0
 end

 gui.drawBox(207, 152, 239, 159, 0x7F000000, 0x7F000000)
 gui.pixelText(207, 152, "5 - Stop")
end

function getWildCatchDelay(isSafariZone)
 local key = joypad.get()

 getCatchRngStopInput()

 if key.Select then
  startingCatchAdvances = advances
  catchDelayCounter = 0
  catchRngStop = false
  catchDelay = 0
  catchSkips = 0
  oneTimeCatchRng = false
  currentSeed2 = read32Bit(currentSeedAddr)
 end

 if catchDelayCounter <= 200 and catchDelay == 0 and not catchRngStop then
  local currentSeed3
  local catchAdvancesDelay
  local safariOffset = isSafariZone and 80 or 0

  if read8Bit(catchCheckFlagAddr) == 0x40 and not oneTimeCatchRng then
   currentSeed3 = read32Bit(currentSeedAddr)

   while currentSeed2 ~= currentSeed3 do
    currentSeed2 = LCRNG(currentSeed2, 0x41C6, 0x4E6D, 0x6073)
    catchSkips = catchSkips + 1
   end

   oneTimeCatchRng = true
   catchAdvancesDelay = advances - startingCatchAdvances
  else
   currentSeed2 = read32Bit(currentSeedAddr)
  end

  if catchSkips == 2 and catchAdvancesDelay > 120 - safariOffset then
   catchDelay = catchAdvancesDelay + 1
  elseif catchSkips == 3 and catchAdvancesDelay > 120 - safariOffset then  -- 0 shake
   catchDelay = catchAdvancesDelay
  elseif catchSkips == 4 and catchAdvancesDelay > 120 - safariOffset then  -- 1 shake
   catchDelay = catchAdvancesDelay - 1
  elseif catchSkips == 5 and catchAdvancesDelay > 120 - safariOffset then  -- 2 shake
   catchDelay = catchAdvancesDelay - 2
  elseif catchSkips == 6 and catchAdvancesDelay > 120 - safariOffset then  -- 3 shake
   catchDelay = catchAdvancesDelay - 3
  end

  catchDelayCounter = catchDelayCounter + 1
 end

 return catchDelay
end

function findCatchSeed(seed, delay)
 for i = 1, delay do
  seed = LCRNG(seed, 0x41C6, 0x4E6D, 0x6073)
 end

 return seed
end

function getCatchRate(speciesDexNumber, isSafariZone)
 if isSafariZone then
  local safariCatchFactor = read8Bit(safariCatchFactorAddr)

  return floor((1275 * safariCatchFactor) / 100)
 else
  return catchRatesList[speciesDexNumber]
 end
end

function getBonusBall(speciesDexNumber, isSafariZone)
 local selectedItem = read16Bit(selectedItemAddr)
 local isBallSelected = selectedItem > 0 and selectedItem < 13

 if isSafariZone then
  return ballRate[6]
 elseif isBallSelected then
  local ballIndex = selectedItem + 1

  if ballIndex == 7 then  -- Net ball catch rate, wild type: 0x0B = Water, 0x06 = Bug
   local wildType1 = read8Bit(wildTypeAddr)
   local wildType2 = read8Bit(wildTypeAddr + 0x1)
   ballRate[7] = (wildType1 == 0x0B or wildType2 == 0x0B or wildType1 == 0x06 or wildType2 == 0x06) and 30 or 10
  elseif ballIndex == 8 then  -- Dive ball catch rate
   local isUnderWaterBattle = read8Bit(mapTypeAddr) == 0x5
   ballRate[8] = isUnderWaterBattle and 35 or 10
  elseif ballIndex == 9 then  -- Nest ball catch rate
   local level = read8Bit(wildAddr + 0x54)
   ballRate[9] = level < 30 and 40 - level or 10
  elseif ballIndex == 10 then  -- Repeat ball catch rate
   local dexMask = lshift(1, (speciesDexNumber - 1) % 8)
   local dexIndex = (speciesDexNumber - 1) / 8
   local dexOwnedFlag = band(read8Bit(saveBlock2Addr + 0x28 + dexIndex), dexMask)
   local dexSeenFlag = band(read8Bit(saveBlock2Addr + 0x5C + dexIndex), dexMask)
   local dexSeen1Flag = band(read8Bit(saveBlock1Addr + 0x938 + dexIndex), dexMask)
   local dexSeen2Flag = band(read8Bit(saveBlock1Addr + 0x3A8C + dexIndex), dexMask)
   local isCatchedPokemon = dexOwnedFlag == dexSeenFlag and dexOwnedFlag == dexSeen1Flag and dexOwnedFlag == dexSeen2Flag
   ballRate[10] = isCatchedPokemon and 30 or 10
  elseif ballIndex == 11 then  -- Timer ball catch rate, bonusBall is x4 if battle turns are >= 30
   local battleTurnsCounter = read8Bit(battleTurnsCounterAddr)
   ballRate[11] = battleTurnsCounter < 30 and battleTurnsCounter + 10 or 40
  end

  return ballRate[ballIndex]
 else  -- Not in safari zone and no ball selected
  return 10
 end
end

function getBonusStatus()
 local status = read8Bit(wildAddr + 0x50)

 if status == 0 then  -- No altered status condition
  return 10
 elseif (status > 0 and status < 0x8) or status == 0x20 then  -- Sleeping, freezed
  return 20
 else  -- Poisoned, burned, paralyzed, badly poisoned
  return 15
 end
end

function calcCatchProbability(isSafariZone)
 local HPmax = read16Bit(wildAddr + 0x58)
 local HPcurrent = read16Bit(wildAddr + 0x56)
 local speciesDexIndex = read16Bit(speciesDexIndexAddr)
 local speciesDexNumber = nationalDexList[speciesDexIndex + 1]
 local catchRate = getCatchRate(speciesDexNumber, isSafariZone)
 local bonusBall = getBonusBall(speciesDexNumber, isSafariZone)
 local bonusStatus = getBonusStatus()

 local a = floor((((((3 * (HPmax == 0 and 1 or HPmax)) - (2 * (HPcurrent == 0 and 1 or HPcurrent))) * ((catchRate * bonusBall) / 10))
           / (3 * (HPmax == 0 and 1 or HPmax))) * bonusStatus) / 10)

 return floor(1048560 / (sqrt(sqrt(16711680 / (a == 0 and 1 or a)))))
end

function findSureCatch(seed, catchProbability, isSafariZone)
 local tempSeed = seed
 local delay = 0
 local ballShakes = 0

 while ballShakes ~= 4 do
  ballShakes = 0

  while rshift(seed, 16) < catchProbability and ballShakes < 4 do
   ballShakes = ballShakes + 1
   seed = LCRNG(seed, 0x41C6, 0x4E6D, 0x6073)
  end

  if isSafariZone and delay % 2 ~= 0 then
   ballShakes = 0
  end

  tempSeed = LCRNG(tempSeed, 0x41C6, 0x4E6D, 0x6073)
  seed = tempSeed

  if ballShakes ~= 4 then
   delay = delay + 1
  end
 end

 return isSafariZone and delay / 2 or delay
end

function catchRng()
 local isSafariZone = read16Bit(safariZoneStepsCounterAddr) ~= 0
 local wildCatchDelay = getWildCatchDelay(isSafariZone)

 if wildCatchDelay <= 0 then
  gui.drawBox(0, 109, 96, 116, 0x7F000000, 0x7F000000)
  gui.pixelText(0, 109, "Delay not calculated yet")
 else
  local catchSeed = findCatchSeed(read32Bit(currentSeedAddr), wildCatchDelay)
  local sureCatchDelay = findSureCatch(catchSeed, calcCatchProbability(isSafariZone), isSafariZone)

  gui.drawBox(0, 109, 132, 123, 0x7F000000, 0x7F000000)
  gui.pixelText(0, 109, "Delay calculated")
  gui.pixelText(0, 116, "100% catch missing advances: "..sureCatchDelay)
 end
end

function getDayCareInfo()
 local eggStepsCounter = 255 - read8Bit(eggLowPIDAddr - 0x4)
 local eggFlagAddr = saveBlock1Addr + 0x1230
 local isEggReady = band(rshift(read8Bit(eggFlagAddr), 6), 0x1) == 1

 return isEggReady, eggStepsCounter
end

function showDayCareInfo()
 local isEggReady, eggStepsCounter = getDayCareInfo()

 gui.drawBox(140, 0, 239, 28, 0x7F000000, 0x7F000000)

 if not isEggReady then
  gui.pixelText(140, 0, "Steps Counter: "..eggStepsCounter)
  gui.pixelText(140, 7, "Egg is not ready")
 end

 if isEggReady then
  local eggLowPid = read16Bit(eggLowPIDAddr)

  gui.pixelText(140, 0, "Egg generated, go get it!")
  gui.pixelText(140, 7, string.format("Egg lower PID: %04X", eggLowPid))
 elseif eggStepsCounter == 1 then
  gui.pixelText(140, 14, "Next step might generate")
  gui.pixelText(140, 21, "an egg!")
 elseif eggStepsCounter == 0 then
  gui.pixelText(140, 14, "255th step taken")
 else
  gui.pixelText(140, 14, "Keep on steppin'")
 end
end

function isEgg(addr)
 return read16Bit(addr + 0x12) == 0x601
end

function showPartyEggInfo()
 local partySlotsCounter = read8Bit(partySlotsCounterAddr) - 1
 local lastPartySlotAddr = partyAddr + (partySlotsCounter * 0x64)

 if isEgg(lastPartySlotAddr) then
  showInfo(lastPartySlotAddr)
 end
end

function getInfoInput()
 local key = input.get()

 local leftInfoArrowColor = "gray"
 local rightInfoArrowColor = "gray"

 if (key["Number3"] or key["Keypad3"]) and (not prevKeyInfo["Number3"] and not prevKeyInfo["Keypad3"]) then
  leftInfoArrowColor = "orange"
  infoIndex = infoIndex - 1 < 1 and 4 or infoIndex - 1
 elseif (key["Number4"] or key["Keypad4"]) and (not prevKeyInfo["Number4"] and not prevKeyInfo["Keypad4"]) then
  rightInfoArrowColor = "orange"
  infoIndex = infoIndex + 1 > 4 and 1 or infoIndex + 1
 end

 prevKeyInfo = key
 gui.drawBox(139, 0, 239, 14, 0x7F000000, 0x7F000000)
 gui.pixelText(139, 7, "Mode: "..infoMode[infoIndex])
 drawArrowLeft(140, 0, leftInfoArrowColor)
 gui.pixelText(148, 0, "3 - 4")
 drawArrowRight(176, 0, rightInfoArrowColor)
end

function showPokemonIDs(addr)
 local pokemonTID, pokemonSID = getPokemonIDs(addr)

 gui.pixelText(199, 145, string.format("TID: %d", pokemonTID))
 gui.pixelText(199, 152, string.format("SID: %d", pokemonSID))
end

function showPokemonInfo()
 if infoMode[infoIndex] == "Gift" then
  local partySlotsCounter = read8Bit(partySlotsCounterAddr) - 1
  local lastPartySlotAddr = partyAddr + (partySlotsCounter * 0x64)

  showInfo(lastPartySlotAddr)
  showPokemonIDs(lastPartySlotAddr)
 elseif infoMode[infoIndex] == "Party" then
  local partySlotsCounter = read8Bit(partySlotsCounterAddr) - 1
  local partySelectedSlotIndex = read8Bit(partySelectedSlotIndexAddr + (partySlotsCounter * 0x88))
  local partySelectedPokemonAddr = partyAddr + (partySelectedSlotIndex * 0x64)

  showInfo(partySelectedPokemonAddr)
  showPokemonIDs(partySelectedPokemonAddr)
 elseif infoMode[infoIndex] == "Box" then
  local currBoxIndex = read8Bit(currBoxIndexAddr)
  local boxAddr = currBoxIndexAddr + 0x4
  local boxSelectedSlotIndex = read8Bit(boxSelectedSlotIndexAddr)
  local boxSelectedPokemonAddr = boxAddr + (0x1E * currBoxIndex * 0x50) + (boxSelectedSlotIndex * 0x50)

  showInfo(boxSelectedPokemonAddr)
  showPokemonIDs(boxSelectedPokemonAddr)
 elseif infoMode[infoIndex] == "Stats" then
  showInfo(pokemonStatsScreenAddr)
  showPokemonIDs(pokemonStatsScreenAddr)
 end
end

function setSaveStateValues()
 initialSeed = userdata.get("seed")
 tempCurrentSeed = userdata.get("temp")
 advances = userdata.get("advances")
end

event.onloadstate(setSaveStateValues)

while not wrongGameVersion do
 setBackgroundBoxes()
 getInput()
 showRngInfo()

 if mode[index] ~= "None" and mode[index] ~= "100% Catch" then
  getRngInfoInput()

  if mode[index] ~= "Pokemon Info" then
   showTrainerIDs()
  end
 elseif mode[index] == "100% Catch" then
  getInstructionsInput()
 end

 if mode[index] == "Capture" then
  showInfo(wildAddr)
  getRoamerInput()

  if showRoamerInfoText then
   showRoamerInfo()
  end
 elseif mode[index] == "100% Catch" then
  catchRng()
 elseif mode[index] == "Breeding" then
  showDayCareInfo()
  showPartyEggInfo()
 elseif mode[index] == "Pokemon Info" then
  getInfoInput()
  showPokemonInfo()
 end

 emu.frameadvance()
end