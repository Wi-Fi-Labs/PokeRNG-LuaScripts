-- My Pokémon Ranch RNG info for Dolphin (Dolphin Lua Core): the rand() seed with the advances made
-- since the script started, and the Phione/Mew that Hayley offers while her special proposal runs.

----------------------------------------------------------------------------------------------------
-- Memory
----------------------------------------------------------------------------------------------------

local read8Bit = ReadValue8

local function read32Bit(addr)
 return ReadValue32(addr) & 0xFFFFFFFF
end

-- The PK4 keeps the DS byte order (little-endian), while ReadValue16/ReadValue32 read the Wii's
-- big-endian order: its values are read byte by byte
local function readLE16Bit(addr)
 return (read8Bit(addr) & 0xFF) | ((read8Bit(addr + 1) & 0xFF) << 8)
end

local function readLE32Bit(addr)
 return readLE16Bit(addr) | (readLE16Bit(addr + 2) << 16)
end

local function isPointer(value)
 return value % 4 == 0 and ((value >= 0x80000000 and value < 0x81800000) or (value >= 0x90000000 and value < 0x94000000))
end

----------------------------------------------------------------------------------------------------
-- Names
-- Not used by the text: itemNames (readPokemon decodes the held item) and speciesAbilities (the
-- abilities of each species).
----------------------------------------------------------------------------------------------------

local natureNames = {
 "Hardy", "Lonely", "Brave", "Adamant", "Naughty",
 "Bold", "Docile", "Relaxed", "Impish", "Lax",
 "Timid", "Hasty", "Serious", "Jolly", "Naive",
 "Modest", "Mild", "Quiet", "Bashful", "Rash",
 "Calm", "Gentle", "Sassy", "Careful", "Quirky"}

local hiddenPowerTypeNames = {
 "Fighting", "Flying", "Poison", "Ground",
 "Rock", "Bug", "Ghost", "Steel",
 "Fire", "Water", "Grass", "Electric",
 "Psychic", "Ice", "Dragon", "Dark"}

local speciesNames = {
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
 "Latias", "Latios",  "Kyogre", "Groudon", "Rayquaza", "Jirachi", "Deoxys",
 -- Gen 4
 "Turtwig", "Grotle", "Torterra", "Chimchar", "Monferno", "Infernape", "Piplup", "Prinplup", "Empoleon", "Starly",
 "Staravia", "Staraptor", "Bidoof", "Bibarel", "Kricketot", "Kricketune", "Shinx", "Luxio", "Luxray", "Budew",
 "Roserade", "Cranidos", "Rampardos", "Shieldon", "Bastiodon", "Burmy", "Wormadam", "Mothim", "Combee", "Vespiquen",
 "Pachirisu", "Buizel", "Floatzel", "Cherubi", "Cherrim", "Shellos", "Gastrodon", "Ambipom", "Drifloon", "Drifblim",
 "Buneary", "Lopunny", "Mismagius", "Honchkrow", "Glameow", "Purugly", "Chingling", "Stunky", "Skuntank", "Bronzor",
 "Bronzong", "Bonsly", "Mime Jr.", "Happiny", "Chatot", "Spiritomb", "Gible", "Gabite", "Garchomp", "Munchlax",
 "Riolu", "Lucario", "Hippopotas", "Hippowdon", "Skorupi", "Drapion", "Croagunk", "Toxicroak", "Carnivine", "Finneon",
 "Lumineon", "Mantyke", "Snover", "Abomasnow", "Weavile", "Magnezone", "Lickilicky", "Rhyperior", "Tangrowth",
 "Electivire", "Magmortar", "Togekiss", "Yanmega", "Leafeon", "Glaceon", "Gliscor", "Mamoswine", "Porygon-Z",
 "Gallade", "Probopass", "Dusknoir", "Froslass", "Rotom", "Uxie", "Mesprit", "Azelf", "Dialga", "Palkia", "Heatran",
 "Regigigas", "Giratina", "Cresselia", "Phione", "Manaphy", "Darkrai", "Shaymin", "Arceus"}

local abilityNames = {
 -- Gen 3
 "Stench", "Drizzle", "Speed Boost", "Battle Armor", "Sturdy", "Damp", "Limber", "Sand Veil", "Static",
 "Volt Absorb", "Water Absorb", "Oblivious", "Cloud Nine", "Compound Eyes", "Insomnia", "Color Change", "Immunity",
 "Flash Fire", "Shield Dust", "Own Tempo", "Suction Cups", "Intimidate", "Shadow Tag", "Rough Skin", "Wonder Guard",
 "Levitate", "Effect Spore", "Synchronize", "Clear Body", "Natural Cure", "Lightning Rod", "Serene Grace",
 "Swift Swim", "Chlorophyll", "Illuminate", "Trace", "Huge Power", "Poison Point", "Inner Focus", "Magma Armor",
 "Water Veil", "Magnet Pull", "Soundproof", "Rain Dish", "Sand Stream", "Pressure", "Thick Fat", "Early Bird",
 "Flame Body", "Run Away", "Keen Eye", "Hyper Cutter", "Pickup", "Truant", "Hustle", "Cute Charm", "Plus", "Minus",
 "Forecast", "Sticky Hold", "Shed Skin", "Guts", "Marvel Scale", "Liquid Ooze", "Overgrow", "Blaze", "Torrent",
 "Swarm", "Rock Head", "Drought", "Arena Trap", "Vital Spirit", "White Smoke", "Pure Power", "Shell Armor",
 "Air Lock",
 -- Gen 4
 "Tangled Feet", "Motor Drive", "Rivalry", "Steadfast", "Snow Cloak", "Gluttony", "Anger Point", "Unburden",
 "Heatproof", "Simple", "Dry Skin", "Download", "Iron Fist", "Poison Heal", "Adaptability", "Skill Link", "Hydration",
 "Solar Power", "Quick Feet", "Normalize", "Sniper", "Magic Guard", "No Guard", "Stall", "Technician", "Leaf Guard",
 "Klutz", "Mold Breaker", "Super Luck", "Aftermath", "Anticipation", "Forewarn", "Unaware", "Tinted Lens", "Filter",
 "Slow Start", "Scrappy", "Storm Drain", "Ice Body", "Solid Rock", "Snow Warning", "Honey Gather", "Frisk", "Reckless",
 "Multitype", "Flower Gift", "Bad Dreams"}

local speciesAbilities = {
 [1] = {65}, [2] = {65}, [3] = {65}, [4] = {66}, [5] = {66}, [6] = {66}, [7] = {67}, [8] = {67},
 [9] = {67}, [10] = {19}, [11] = {61}, [12] = {14}, [13] = {19}, [14] = {61}, [15] = {68}, [16] = {51, 77},
 [17] = {51, 77}, [18] = {51, 77}, [19] = {50, 62}, [20] = {50, 62}, [21] = {51}, [22] = {51}, [23] = {22, 61},
 [24] = {22, 61}, [25] = {9}, [26] = {9}, [27] = {8}, [28] = {8}, [29] = {38, 79}, [30] = {38, 79},
 [31] = {38, 79}, [32] = {38, 79}, [33] = {38, 79}, [34] = {38, 79}, [35] = {56, 98}, [36] = {56, 98}, [37] = {18},
 [38] = {18}, [39] = {56}, [40] = {56}, [41] = {39}, [42] = {39}, [43] = {34}, [44] = {34}, [45] = {34},
 [46] = {27, 87}, [47] = {27, 87}, [48] = {14, 110}, [49] = {19, 110}, [50] = {8, 71}, [51] = {8, 71}, [52] = {53, 101},
 [53] = {7, 101}, [54] = {6, 13}, [55] = {6, 13}, [56] = {72, 83}, [57] = {72, 83}, [58] = {22, 18}, [59] = {22, 18},
 [60] = {11, 6}, [61] = {11, 6}, [62] = {11, 6}, [63] = {28, 39}, [64] = {28, 39}, [65] = {28, 39}, [66] = {62, 99},
 [67] = {62, 99}, [68] = {62, 99}, [69] = {34}, [70] = {34}, [71] = {34}, [72] = {29, 64}, [73] = {29, 64}, [74] = {69, 5},
 [75] = {69, 5}, [76] = {69, 5}, [77] = {50, 18}, [78] = {50, 18}, [79] = {12, 20}, [80] = {12, 20}, [81] = {42, 5},
 [82] = {42, 5}, [83] = {51, 39}, [84] = {50, 48}, [85] = {50, 48}, [86] = {47, 93}, [87] = {47, 93}, [88] = {1, 60},
 [89] = {1, 60}, [90] = {75, 92}, [91] = {75, 92}, [92] = {26}, [93] = {26}, [94] = {26}, [95] = {69, 5}, [96] = {15, 108},
 [97] = {15, 108}, [98] = {52, 75}, [99] = {52, 75}, [100] = {43, 9}, [101] = {43, 9}, [102] = {34}, [103] = {34}, [104] = {69, 31},
 [105] = {69, 31}, [106] = {7, 120}, [107] = {51, 89}, [108] = {20, 12}, [109] = {26}, [110] = {26}, [111] = {31, 69}, [112] = {31, 69},
 [113] = {30, 32}, [114] = {34, 102}, [115] = {48, 113}, [116] = {33, 97}, [117] = {38, 97}, [118] = {33, 41}, [119] = {33, 41},
 [120] = {35, 30}, [121] = {35, 30}, [122] = {43, 111}, [123] = {68, 101}, [124] = {12, 108}, [125] = {9}, [126] = {49}, [127] = {52, 104},
 [128] = {22, 83}, [129] = {33}, [130] = {22}, [131] = {11, 75}, [132] = {7}, [133] = {50, 91}, [134] = {11}, [135] = {10}, [136] = {18},
 [137] = {36, 88}, [138] = {33, 75}, [139] = {33, 75}, [140] = {33, 4}, [141] = {33, 4}, [142] = {69, 46}, [143] = {17, 47}, [144] = {46},
 [145] = {46}, [146] = {46}, [147] = {61}, [148] = {61}, [149] = {39}, [150] = {46}, [151] = {28}, [152] = {65}, [153] = {65}, [154] = {65},
 [155] = {66}, [156] = {66}, [157] = {66}, [158] = {67}, [159] = {67}, [160] = {67}, [161] = {50, 51}, [162] = {50, 51}, [163] = {15, 51},
 [164] = {15, 51}, [165] = {68, 48}, [166] = {68, 48}, [167] = {68, 15}, [168] = {68, 15}, [169] = {39}, [170] = {10, 35}, [171] = {10, 35},
 [172] = {9}, [173] = {56, 98}, [174] = {56}, [175] = {55, 32}, [176] = {55, 32}, [177] = {28, 48}, [178] = {28, 48}, [179] = {9},
 [180] = {9}, [181] = {9}, [182] = {34}, [183] = {47, 37}, [184] = {47, 37}, [185] = {5, 69}, [186] = {11, 6}, [187] = {34, 102},
 [188] = {34, 102}, [189] = {34, 102}, [190] = {50, 53}, [191] = {34, 94}, [192] = {34, 94}, [193] = {3, 14}, [194] = {6, 11}, [195] = {6, 11},
 [196] = {28}, [197] = {28}, [198] = {15, 105}, [199] = {12, 20}, [200] = {26}, [201] = {26}, [202] = {23}, [203] = {39, 48}, [204] = {5},
 [205] = {5}, [206] = {32, 50}, [207] = {52, 8}, [208] = {69, 5}, [209] = {22, 50}, [210] = {22, 95}, [211] = {38, 33}, [212] = {68, 101},
 [213] = {5, 82}, [214] = {68, 62}, [215] = {39, 51}, [216] = {53, 95}, [217] = {62, 95}, [218] = {40, 49}, [219] = {40, 49}, [220] = {12, 81},
 [221] = {12, 81}, [222] = {55, 30}, [223] = {55, 97}, [224] = {21, 97}, [225] = {72, 55}, [226] = {33, 11}, [227] = {51, 5}, [228] = {48, 18},
 [229] = {48, 18}, [230] = {33, 97}, [231] = {53}, [232] = {5}, [233] = {36, 88}, [234] = {22, 119}, [235] = {20, 101}, [236] = {62, 80},
 [237] = {22, 101}, [238] = {12, 108}, [239] = {9}, [240] = {49}, [241] = {47, 113}, [242] = {30, 32}, [243] = {46}, [244] = {46}, [245] = {46},
 [246] = {62}, [247] = {61}, [248] = {45}, [249] = {46}, [250] = {46}, [251] = {30}, [252] = {65}, [253] = {65}, [254] = {65}, [255] = {66},
 [256] = {66}, [257] = {66}, [258] = {67}, [259] = {67}, [260] = {67}, [261] = {50, 95}, [262] = {22, 95}, [263] = {53, 82}, [264] = {53, 82},
 [265] = {19}, [266] = {61}, [267] = {68}, [268] = {61}, [269] = {19}, [270] = {33, 44}, [271] = {33, 44}, [272] = {33, 44}, [273] = {34, 48},
 [274] = {34, 48}, [275] = {34, 48}, [276] = {62}, [277] = {62}, [278] = {51}, [279] = {51}, [280] = {28, 36}, [281] = {28, 36}, [282] = {28, 36},
 [283] = {33}, [284] = {22}, [285] = {27, 90}, [286] = {27, 90}, [287] = {54}, [288] = {72}, [289] = {54}, [290] = {14}, [291] = {3}, [292] = {25},
 [293] = {43}, [294] = {43}, [295] = {43}, [296] = {47, 62}, [297] = {47, 62}, [298] = {47, 37}, [299] = {5, 42}, [300] = {56, 96}, [301] = {56, 96},
 [302] = {51, 100}, [303] = {52, 22}, [304] = {5, 69}, [305] = {5, 69}, [306] = {5, 69}, [307] = {74}, [308] = {74}, [309] = {9, 31}, [310] = {9, 31},
 [311] = {57}, [312] = {58}, [313] = {35, 68}, [314] = {12, 110}, [315] = {30, 38}, [316] = {64, 60}, [317] = {64, 60}, [318] = {24}, [319] = {24},
 [320] = {41, 12}, [321] = {41, 12}, [322] = {12, 86}, [323] = {40, 116}, [324] = {73}, [325] = {47, 20}, [326] = {47, 20}, [327] = {20, 77},
 [328] = {52, 71}, [329] = {26}, [330] = {26}, [331] = {8}, [332] = {8}, [333] = {30}, [334] = {30}, [335] = {17}, [336] = {61}, [337] = {26},
 [338] = {26}, [339] = {12, 107}, [340] = {12, 107}, [341] = {52, 75}, [342] = {52, 75}, [343] = {26}, [344] = {26}, [345] = {21}, [346] = {21},
 [347] = {4}, [348] = {4}, [349] = {33}, [350] = {63}, [351] = {59}, [352] = {16}, [353] = {15, 119}, [354] = {15, 119}, [355] = {26}, [356] = {46},
 [357] = {34, 94}, [358] = {26}, [359] = {46, 105}, [360] = {23}, [361] = {39, 115}, [362] = {39, 115}, [363] = {47, 115}, [364] = {47, 115},
 [365] = {47, 115}, [366] = {75}, [367] = {33}, [368] = {33}, [369] = {33, 69}, [370] = {33}, [371] = {69}, [372] = {69}, [373] = {22}, [374] = {29},
 [375] = {29}, [376] = {29}, [377] = {29}, [378] = {29}, [379] = {29}, [380] = {26}, [381] = {26}, [382] = {2}, [383] = {70}, [384] = {76},
 [385] = {32}, [386] = {46}, [387] = {65}, [388] = {65}, [389] = {65}, [390] = {66}, [391] = {66}, [392] = {66}, [393] = {67}, [394] = {67},
 [395] = {67}, [396] = {51}, [397] = {22}, [398] = {22}, [399] = {86, 109}, [400] = {86, 109}, [401] = {61}, [402] = {68}, [403] = {79, 22},
 [404] = {79, 22}, [405] = {79, 22}, [406] = {30, 38}, [407] = {30, 38}, [408] = {104}, [409] = {104}, [410] = {5}, [411] = {5}, [412] = {61},
 [413] = {107}, [414] = {68}, [415] = {118}, [416] = {46}, [417] = {50, 53}, [418] = {33}, [419] = {33}, [420] = {34}, [421] = {122},
 [422] = {60, 114}, [423] = {60, 114}, [424] = {101, 53}, [425] = {106, 84}, [426] = {106, 84}, [427] = {50, 103}, [428] = {56, 103}, [429] = {26},
 [430] = {15, 105}, [431] = {7, 20}, [432] = {47, 20}, [433] = {26}, [434] = {1, 106}, [435] = {1, 106}, [436] = {26, 85}, [437] = {26, 85},
 [438] = {5, 69}, [439] = {43, 111}, [440] = {30, 32}, [441] = {51, 77}, [442] = {46}, [443] = {8}, [444] = {8}, [445] = {8}, [446] = {53, 47},
 [447] = {80, 39}, [448] = {80, 39}, [449] = {45}, [450] = {45}, [451] = {4, 97}, [452] = {4, 97}, [453] = {107, 87}, [454] = {107, 87}, [455] = {26},
 [456] = {33, 114}, [457] = {33, 114}, [458] = {33, 11}, [459] = {117}, [460] = {117}, [461] = {46}, [462] = {42, 5}, [463] = {20, 12},
 [464] = {31, 116}, [465] = {34, 102}, [466] = {78}, [467] = {49}, [468] = {55, 32}, [469] = {3, 110}, [470] = {102}, [471] = {81}, [472] = {52, 8},
 [473] = {12, 81}, [474] = {91, 88}, [475] = {80}, [476] = {5, 42}, [477] = {46}, [478] = {81}, [479] = {26}, [480] = {26}, [481] = {26}, [482] = {26},
 [483] = {46}, [484] = {46}, [485] = {18}, [486] = {112}, [487] = {46}, [488] = {26}, [489] = {93}, [490] = {93}, [491] = {123}, [492] = {30},
 [493] = {121}}

local moveNames = {
 -- Gen 1
 "--", "Pound", "Karate Chop", "Double Slap", "Comet Punch", "Mega Punch", "Pay Day", "Fire Punch", "Ice Punch",
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
 "Super Fang", "Slash", "Substitute", "Struggle",
 -- Gen 2
 "Sketch", "Triple Kick", "Thief", "Spider Web", "Mind Reader",
 "Nightmare", "Flame Wheel", "Snore", "Curse", "Flail", "Conversion 2", "Aeroblast", "Cotton Spore", "Reversal",
 "Spite", "Powder Snow", "Protect", "Mach Punch", "Scary Face", "Feint Attack", "Sweet Kiss", "Belly Drum",
 "Sludge Bomb", "Mud-Slap", "Octazooka", "Spikes", "Zap Cannon", "Foresight", "Destiny Bond", "Perish Song",
 "Icy Wind", "Detect", "Bone Rush", "Lock-On", "Outrage", "Sandstorm", "Giga Drain", "Endure", "Charm", "Rollout",
 "False Swipe", "Swagger", "Milk Drink", "Spark", "Fury Cutter", "Steel Wing", "Mean Look", "Attract", "Sleep Talk",
 "Heal Bell", "Return", "Present", "Frustration", "Safeguard", "Pain Split", "Sacred Fire", "Magnitude",
 "Dynamic Punch", "Megahorn", "Dragon Breath", "Baton Pass", "Encore", "Pursuit", "Rapid Spin", "Sweet Scent",
 "Iron Tail", "Metal Claw", "Vital Throw", "Morning Sun", "Synthesis", "Moonlight", "Hidden Power", "Cross Chop",
 "Twister", "Rain Dance", "Sunny Day", "Crunch", "Mirror Coat", "Psych Up", "Extreme Speed", "Ancient Power",
 "Shadow Ball", "Future Sight", "Rock Smash", "Whirlpool", "Beat Up",
 -- Gen 3
 "Fake Out", "Uproar", "Stockpile", "Spit Up", "Swallow", "Heat Wave", "Hail", "Torment", "Flatter", "Will-O-Wisp",
 "Memento", "Facade", "Focus Punch", "Smelling Salts", "Follow Me", "Nature Power", "Charge", "Taunt", "Helping Hand",
 "Trick", "Role Play", "Wish", "Assist", "Ingrain", "Superpower", "Magic Coat", "Recycle", "Revenge", "Brick Break",
 "Yawn", "Knock Off", "Endeavor", "Eruption", "Skill Swap", "Imprison", "Refresh", "Grudge", "Snatch", "Secret Power",
 "Dive", "Arm Thrust", "Camouflage", "Tail Glow", "Luster Purge", "Mist Ball", "Feather Dance", "Teeter Dance",
 "Blaze Kick", "Mud Sport", "Ice Ball", "Needle Arm", "Slack Off", "Hyper Voice", "Poison Fang", "Crush Claw",
 "Blast Burn", "Hydro Cannon", "Meteor Mash", "Astonish", "Weather Ball", "Aromatherapy", "Fake Tears", "Air Cutter",
 "Overheat", "Odor Sleuth", "Rock Tomb", "Silver Wind", "Metal Sound", "Grass Whistle", "Tickle", "Cosmic Power",
 "Water Spout", "Signal Beam", "Shadow Punch", "Extrasensory", "Sky Uppercut", "Sand Tomb", "Sheer Cold", "Muddy Water",
 "Bullet Seed", "Aerial Ace", "Icicle Spear", "Iron Defense", "Block", "Howl", "Dragon Claw", "Frenzy Plant", "Bulk Up",
 "Bounce", "Mud Shot", "Poison Tail", "Covet", "Volt Tackle", "Magical Leaf", "Water Sport", "Calm Mind", "Leaf Blade",
 "Dragon Dance", "Rock Blast", "Shock Wave", "Water Pulse", "Doom Desire", "Psycho Boost",
 -- Gen 4
 "Roost", "Gravity", "Miracle Eye", "Wake-Up Slap", "Hammer Arm", "Gyro Ball", "Healing Wish", "Brine", "Natural Gift",
 "Feint", "Pluck", "Tailwind", "Acupressure", "Metal Burst", "U-turn", "Close Combat", "Payback", "Assurance", "Embargo",
 "Fling", "Psycho Shift", "Trump Card", "Heal Block", "Wring Out", "Power Trick", "Gastro Acid", "Lucky Chant", "Me First",
 "Copycat", "Power Swap", "Guard Swap", "Punishment", "Last Resort", "Worry Seed", "Sucker Punch", "Toxic Spikes",
 "Heart Swap", "Aqua Ring", "Magnet Rise", "Flare Blitz", "Force Palm", "Aura Sphere", "Rock Polish", "Poison Jab",
 "Dark Pulse", "Night Slash", "Aqua Tail", "Seed Bomb", "Air Slash", "X-Scissor", "Bug Buzz", "Dragon Pulse", "Dragon Rush",
 "Power Gem", "Drain Punch", "Vacuum Wave", "Focus Blast", "Energy Ball", "Brave Bird", "Earth Power", "Switcheroo",
 "Giga Impact", "Nasty Plot", "Bullet Punch", "Avalanche", "Ice Shard", "Shadow Claw", "Thunder Fang", "Ice Fang",
 "Fire Fang", "Shadow Sneak", "Mud Bomb", "Psycho Cut", "Zen Headbutt", "Mirror Shot", "Flash Cannon", "Rock Climb",
 "Defog", "Trick Room", "Draco Meteor", "Discharge", "Lava Plume", "Leaf Storm", "Power Whip", "Rock Wrecker",
 "Cross Poison", "Gunk Shot", "Iron Head", "Magnet Bomb", "Stone Edge", "Captivate", "Stealth Rock", "Grass Knot", "Chatter",
 "Judgment", "Bug Bite", "Charge Beam", "Wood Hammer", "Aqua Jet", "Attack Order", "Defend Order", "Heal Order", "Head Smash",
 "Double Hit", "Roar of Time", "Spacial Rend", "Lunar Dance", "Crush Grip", "Magma Storm", "Dark Void", "Seed Flare",
 "Ominous Wind", "Shadow Force"}

local itemNames = {
 "None", "Master Ball", "Ultra Ball", "Great Ball", "Poké Ball", "Safari Ball", "Net Ball", "Dive Ball",
 "Nest Ball", "Repeat Ball", "Timer Ball", "Luxury Ball", "Premier Ball", "Dusk Ball", "Heal Ball",
 "Quick Ball", "Cherish Ball", "Potion", "Antidote", "Burn Heal", "Ice Heal", "Awakening", "Parlyz Heal",
 "Full Restore", "Max Potion", "Hyper Potion", "Super Potion", "Full Heal", "Revive", "Max Revive",
 "Fresh Water", "Soda Pop", "Lemonade", "Moomoo Milk", "EnergyPowder", "Energy Root", "Heal Powder",
 "Revival Herb", "Ether", "Max Ether", "Elixir", "Max Elixir", "Lava Cookie", "Berry Juice",
 "Sacred Ash", "HP Up", "Protein", "Iron", "Carbos", "Calcium", "Rare Candy", "PP Up", "Zinc",
 "PP Max", "Old Gateau", "Guard Spec.", "Dire Hit", "X Attack", "X Defend", "X Speed", "X Accuracy",
 "X Special", "X Sp. Def", "Poké Doll", "Fluffy Tail", "Blue Flute", "Yellow Flute", "Red Flute",
 "Black Flute", "White Flute", "Shoal Salt", "Shoal Shell", "Red Shard", "Blue Shard", "Yellow Shard",
 "Green Shard", "Super Repel", "Max Repel", "Escape Rope", "Repel", "Sun Stone", "Moon Stone",
 "Fire Stone", "Thunderstone", "Water Stone", "Leaf Stone", "TinyMushroom", "Big Mushroom", "Pearl",
 "Big Pearl", "Stardust", "Star Piece", "Nugget", "Heart Scale", "Honey", "Growth Mulch",
 "Damp Mulch", "Stable Mulch", "Gooey Mulch", "Root Fossil", "Claw Fossil", "Helix Fossil", "Dome Fossil",
 "Old Amber", "Armor Fossil", "Skull Fossil", "Rare Bone", "Shiny Stone", "Dusk Stone", "Dawn Stone",
 "Oval Stone", "Odd Keystone", "Griseous Orb", "unknown1", "unknown2", "unknown3", "unknown4", "unknown5",
 "unknown6", "unknown7", "unknown8", "unknown9", "unknown10", "unknown11", "unknown12", "unknown13",
 "unknown14", "unknown15", "unknown16", "unknown17", "unknown18", "unknown19", "unknown20", "unknown21",
 "unknown22", "Adamant Orb", "Lustrous Orb", "Grass Mail", "Flame Mail", "Bubble Mail", "Bloom Mail",
 "Tunnel Mail", "Steel Mail", "Heart Mail", "Snow Mail", "Space Mail", "Air Mail", "Mosaic Mail", "Brick Mail",
 "Cheri Berry", "Chesto Berry", "Pecha Berry", "Rawst Berry", "Aspear Berry", "Leppa Berry", "Oran Berry",
 "Persim Berry", "Lum Berry", "Sitrus Berry", "Figy Berry", "Wiki Berry", "Mago Berry", "Aguav Berry",
 "Iapapa Berry", "Razz Berry", "Bluk Berry", "Nanab Berry", "Wepear Berry", "Pinap Berry", "Pomeg Berry",
 "Kelpsy Berry", "Qualot Berry", "Hondew Berry", "Grepa Berry", "Tamato Berry", "Cornn Berry", "Magost Berry",
 "Rabuta Berry", "Nomel Berry", "Spelon Berry", "Pamtre Berry", "Watmel Berry", "Durin Berry",
 "Belue Berry", "Occa Berry", "Passho Berry", "Wacan Berry", "Rindo Berry", "Yache Berry",
 "Chople Berry", "Kebia Berry", "Shuca Berry", "Coba Berry", "Payapa Berry", "Tanga Berry",
 "Charti Berry", "Kasib Berry", "Haban Berry", "Colbur Berry", "Babiri Berry", "Chilan Berry", "Liechi Berry",
 "Ganlon Berry", "Salac Berry", "Petaya Berry", "Apicot Berry", "Lansat Berry", "Starf Berry",
 "Enigma Berry", "Micle Berry", "Custap Berry", "Jaboca Berry", "Rowap Berry", "BrightPowder",
 "White Herb", "Macho Brace", "Exp. Share", "Quick Claw", "Soothe Bell", "Mental Herb", "Choice Band",
 "King's Rock", "SilverPowder", "Amulet Coin", "Cleanse Tag", "Soul Dew", "DeepSeaTooth",
 "DeepSeaScale", "Smoke Ball", "Everstone", "Focus Band", "Lucky Egg", "Scope Lens", "Metal Coat",
 "Leftovers", "Dragon Scale", "Light Ball", "Soft Sand", "Hard Stone", "Miracle Seed", "BlackGlasses",
 "Black Belt", "Magnet", "Mystic Water", "Sharp Beak", "Poison Barb", "NeverMeltIce", "Spell Tag",
 "TwistedSpoon", "Charcoal", "Dragon Fang", "Silk Scarf", "Up-Grade", "Shell Bell", "Sea Incense",
 "Lax Incense", "Lucky Punch", "Metal Powder", "Thick Club", "Stick", "Red Scarf", "Blue Scarf",
 "Pink Scarf", "Green Scarf", "Yellow Scarf", "Wide Lens", "Muscle Band", "Wise Glasses", "Expert Belt",
 "Light Clay", "Life Orb", "Power Herb", "Toxic Orb", "Flame Orb", "Quick Powder", "Focus Sash",
 "Zoom Lens", "Metronome", "Iron Ball", "Lagging Tail", "Destiny Knot", "Black Sludge", "Icy Rock",
 "Smooth Rock", "Heat Rock", "Damp Rock", "Grip Claw", "Choice Scarf", "Sticky Barb", "Power Bracer",
 "Power Belt", "Power Lens", "Power Band", "Power Anklet", "Power Weight", "Shed Shell",
 "Big Root", "Choice Specs", "Flame Plate", "Splash Plate", "Zap Plate", "Meadow Plate", "Icicle Plate",
 "Fist Plate", "Toxic Plate", "Earth Plate", "Sky Plate", "Mind Plate", "Insect Plate",
 "Stone Plate", "Spooky Plate", "Draco Plate", "Dread Plate", "Iron Plate", "Odd Incense",
 "Rock Incense", "Full Incense", "Wave Incense", "Rose Incense", "Luck Incense", "Pure Incense",
 "Protector", "Electirizer", "Magmarizer", "Dubious Disc", "Reaper Cloth", "Razor Claw", "Razor Fang",
 "TM01", "TM02", "TM03", "TM04", "TM05", "TM06", "TM07", "TM08", "TM09", "TM10", "TM11", "TM12",
 "TM13", "TM14", "TM15", "TM16", "TM17", "TM18", "TM19", "TM20", "TM21", "TM22", "TM23", "TM24",
 "TM25", "TM26", "TM27", "TM28", "TM29", "TM30", "TM31", "TM32", "TM33", "TM34", "TM35", "TM36",
 "TM37", "TM38", "TM39", "TM40", "TM41", "TM42", "TM43", "TM44", "TM45", "TM46", "TM47", "TM48",
 "TM49", "TM50", "TM51", "TM52", "TM53", "TM54", "TM55", "TM56", "TM57", "TM58", "TM59", "TM60",
 "TM61", "TM62", "TM63", "TM64", "TM65", "TM66", "TM67", "TM68", "TM69", "TM70", "TM71", "TM72",
 "TM73", "TM74", "TM75", "TM76", "TM77", "TM78", "TM79", "TM80", "TM81", "TM82", "TM83", "TM84",
 "TM85", "TM86", "TM87", "TM88", "TM89", "TM90", "TM91", "TM92", "HM01", "HM02", "HM03", "HM04",
 "HM05", "HM06", "HM07", "HM08", "Explorer Kit", "Loot Sack", "Rule Book", "Poké Radar", "Point Card",
 "Journal", "Seal Case", "Fashion Case", "Seal Bag", "Pal Pad", "Works Key", "Old Charm",
 "Galactic Key", "Red Chain", "Town Map", "Vs. Seeker", "Coin Case", "Old Rod", "Good Rod", "Super Rod",
 "Sprayduck", "Poffin Case", "Bicycle", "Suite Key", "Oak's Letter", "Lunar Wing", "Member Card",
 "Azure Flute", "S.S. Ticket", "Contest Pass", "Magma Stone", "Parcel", "Coupon 1", "Coupon 2",
 "Coupon 3", "Storage Key", "SecretPotion", "Vs. Recorder", "Gracidea", "Secret Key",
 "Apricorn Box", "Unown Report", "Berry Pots", "Dowsing MCHN", "Blue Card", "Slowpoke Tail",
 "Clear Bell", "Card Key", "Basement Key", "SquirtBottle", "Red Scale", "Lost Item", "Pass",
 "Machine Part", "Silver Wing", "Rainbow Wing", "Mystery Egg", "Red Apricorn", "Yellow Apricorn",
 "Blue Apricorn", "Green Apricorn", "Pink Apricorn", "White Apricorn", "Black Apricorn", "Fast Ball",
 "Level Ball", "Lure Ball", "Heavy Ball", "Love Ball", "Friend Ball", "Moon Ball",
 "Sport Ball", "Park Ball", "Photo Album", "GB Sounds", "Tidal Bell", "RageCandyBar", "Data Card 01",
 "Data Card 02", "Data Card 03", "Data Card 04", "Data Card 05", "Data Card 06", "Data Card 07",
 "Data Card 08", "Data Card 09", "Data Card 10", "Data Card 11", "Data Card 12", "Data Card 13",
 "Data Card 14", "Data Card 15", "Data Card 16", "Data Card 17", "Data Card 18", "Data Card 19",
 "Data Card 20", "Data Card 21", "Data Card 22", "Data Card 23", "Data Card 24", "Data Card 25",
 "Data Card 26", "Data Card 27", "Jade Orb", "Lock Capsule", "Red Orb", "Blue Orb", "Enigma Stone"}

-- Entry `index` of a name list, or "???" when the index is out of range (the value is not valid)
local function nameAt(list, index)
 return list[index] or "???"
end

----------------------------------------------------------------------------------------------------
-- Builds
----------------------------------------------------------------------------------------------------

-- Keyed by the byte at 0x80004232, part of the build fingerprint at 0x80004230; any other value is
-- treated as the European build.
-- seedAddr: rand() seed
-- offerReturnAddr: return address that the special proposal leaves at frame+4 while the offer runs
-- tradeObjectVtable: vtable of the trade object
-- pk4Offset: offset of the PK4 in the trade object
local BUILDS = {
 [0xB2] = {seedAddr = 0x807790B0, offerReturnAddr = 0x802E57A0, tradeObjectVtable = 0x805AE62C, pk4Offset = 0x1C}, -- E
 [0x0B] = {seedAddr = 0x8076E850, offerReturnAddr = 0x802E2CB4, tradeObjectVtable = 0x805A3E3C, pk4Offset = 0x1C}, -- U
 [0xAD] = {seedAddr = 0x80758878, offerReturnAddr = 0x802D2828, tradeObjectVtable = 0x8058CD44, pk4Offset = 0x1C}, -- J
 [0x2A] = {seedAddr = 0x807C1510, offerReturnAddr = 0x80363528, tradeObjectVtable = 0x80636890, pk4Offset = 0x24}} -- J Pt

----------------------------------------------------------------------------------------------------
-- RNG
----------------------------------------------------------------------------------------------------

-- rand() advances its seed as seed * 0x41C64E6D + 0x3039; RAND_JUMPS[i + 1] advances it by 2^i calls
-- at once
local RAND_JUMPS = {}

do
 local mult, add = 0x41C64E6D, 0x3039

 for i = 1, 32 do
  RAND_JUMPS[i] = {mult = mult, add = add}
  add = (add * mult + add) & 0xFFFFFFFF
  mult = (mult * mult) & 0xFFFFFFFF
 end
end

-- Number of rand() calls from seed `from` to seed `to`; negative when `to` comes first (for example
-- after loading a savestate)
local function advancesBetween(from, to)
 local distance = 0

 for bit = 0, 31 do
  if from == to then
   break
  end

  local mask = 1 << bit

  if ((from ~ to) & mask) ~= 0 then
   local jump = RAND_JUMPS[bit + 1]
   from = (from * jump.mult + jump.add) & 0xFFFFFFFF
   distance = distance + mask
  end
 end

 return distance > 10000000 and distance - 0x100000000 or distance
end

----------------------------------------------------------------------------------------------------
-- Offered Pokémon
----------------------------------------------------------------------------------------------------

-- Address of the PK4 of the Phione/Mew offered by Hayley, or nil when no offer is running.
-- The offer runs inside the function that generated the Pokémon: starting from the OS thread list
-- (0x800000DC), climb each thread's stack (saved r1 at thread+4, next thread at +0x2FC) up to the
-- frame whose word at +4 is the build's offerReturnAddr; the trade object pointer is at frame+0x28.
local function findOfferedPK4(build)
 local thread = read32Bit(0x800000DC)

 for _ = 1, 64 do
  if not isPointer(thread) then
   break
  end

  local frame = read32Bit(thread + 0x4)

  for _ = 1, 256 do
   if not isPointer(frame) then
    break
   end

   if read32Bit(frame + 0x4) == build.offerReturnAddr then
    local object = read32Bit(frame + 0x28)

    if isPointer(object) and read32Bit(object) == object
       and read32Bit(object + build.pk4Offset - 0x8) == build.tradeObjectVtable then
     return object + build.pk4Offset
    end
   end

   frame = read32Bit(frame)
  end

  thread = read32Bit(thread + 0x2FC)
 end

 return nil
end

-- Position (0-3) of block A (species, item, IDs, ability) and of block B (moves, PP, IVs) among the
-- four stored blocks, for each value of ((PID >> 13) & 31) % 24
local BLOCK_A_POSITION = {0,0,0,0,0,0, 1,1,2,3,2,3, 1,1,2,3,2,3, 1,1,2,3,2,3}
local BLOCK_B_POSITION = {1,1,2,3,2,3, 0,0,0,0,0,0, 2,3,1,1,3,2, 2,3,1,1,3,2}

-- The 64 encrypted words at PK4 offsets 0x08-0x87, decrypted and indexed by offset: each word is
-- XORed with the high half of a generator (seed * 0x41C64E6D + 0x6073) started from the checksum
local function decryptWords(pk4Addr, checksum)
 local words = {}
 local seed = checksum

 for offset = 0x08, 0x86, 2 do
  seed = (seed * 0x41C64E6D + 0x6073) & 0xFFFFFFFF
  words[offset] = readLE16Bit(pk4Addr + offset) ~ (seed >> 16)
 end

 return words
end

local function readPokemon(pk4Addr)
 local pid = readLE32Bit(pk4Addr)
 local words = decryptWords(pk4Addr, readLE16Bit(pk4Addr + 0x6))
 local order = ((pid >> 13) & 0x1F) % 24 + 1
 local blockA = 0x08 + 0x20 * BLOCK_A_POSITION[order]
 local blockB = 0x08 + 0x20 * BLOCK_B_POSITION[order]
 local ivs = words[blockB + 0x10] | (words[blockB + 0x12] << 16)

 return {
  pid = pid,
  species = words[blockA],
  heldItem = words[blockA + 0x2],
  tid = words[blockA + 0x4],
  sid = words[blockA + 0x6],
  ability = words[blockA + 0xC] >> 8,
  moves = {words[blockB], words[blockB + 0x2], words[blockB + 0x4], words[blockB + 0x6]},
  movePP = {words[blockB + 0x8] & 0xFF, words[blockB + 0x8] >> 8, words[blockB + 0xA] & 0xFF, words[blockB + 0xA] >> 8},
  ivs = {
   hp = ivs & 0x1F,
   atk = (ivs >> 5) & 0x1F,
   def = (ivs >> 10) & 0x1F,
   speed = (ivs >> 15) & 0x1F,
   spAtk = (ivs >> 20) & 0x1F,
   spDef = (ivs >> 25) & 0x1F}}
end

----------------------------------------------------------------------------------------------------
-- Text
----------------------------------------------------------------------------------------------------

-- Hidden Power type (0-based index in hiddenPowerTypeNames) and power
local function getHiddenPower(ivs)
 local typeBits, powerBits = 0, 0

 for i, iv in ipairs({ivs.hp, ivs.atk, ivs.def, ivs.speed, ivs.spAtk, ivs.spDef}) do
  typeBits = typeBits | ((iv & 1) << (i - 1))
  powerBits = powerBits | (((iv >> 1) & 1) << (i - 1))
 end

 return typeBits * 15 // 63, powerBits * 40 // 63 + 30
end

-- "Move: <name> PP: <pp>", with the name padded to the longest move name so that every "PP" lines up
local MOVE_FORMAT

do
 local width = 0

 for _, name in ipairs(moveNames) do
  width = math.max(width, #name)
 end

 MOVE_FORMAT = "Move: %-"..width.."s PP: %s"
end

local function getMoveText(move, pp)
 return string.format(MOVE_FORMAT, nameAt(moveNames, move + 1), pp)
end

local function getPokemonText(pokemon)
 local ivs = pokemon.ivs
 local hpType, hpPower = getHiddenPower(ivs)
 local lines = {
  string.format("Species: %s", nameAt(speciesNames, pokemon.species)),
  string.format("PID: %08X", pokemon.pid),
  string.format("Nature: %s", natureNames[pokemon.pid % 25 + 1]),
  -- ability slot as in PokéFinder and PKHeX: bit 0 of the PID
  string.format("Ability: %s (%d)", nameAt(abilityNames, pokemon.ability), pokemon.pid & 1),
  string.format("IVs: %02d/%02d/%02d/%02d/%02d/%02d", ivs.hp, ivs.atk, ivs.def, ivs.spAtk, ivs.spDef, ivs.speed),
  string.format("HPower: %s %02d", hiddenPowerTypeNames[hpType + 1], hpPower),
  ""}

 for i = 1, 4 do
  lines[#lines + 1] = getMoveText(pokemon.moves[i], pokemon.movePP[i])
 end

 lines[#lines + 1] = ""
 lines[#lines + 1] = ""
 lines[#lines + 1] = string.format("TID: %s", pokemon.tid)
 lines[#lines + 1] = string.format("SID: %s", pokemon.sid)

 return table.concat(lines, "\n")
end

----------------------------------------------------------------------------------------------------
-- Dolphin callbacks
----------------------------------------------------------------------------------------------------

local build, initialSeed, lastSeed, advances

function onScriptStart()
 build = BUILDS[read8Bit(0x80004232) & 0xFF] or BUILDS[0xB2]
 initialSeed = read32Bit(build.seedAddr)
 lastSeed = initialSeed
 advances = 0
end

function onScriptUpdate()
 local currentSeed = read32Bit(build.seedAddr)
 advances = advances + advancesBetween(lastSeed, currentSeed)
 lastSeed = currentSeed

 local pk4Addr = findOfferedPK4(build)
 local offerText = pk4Addr and getPokemonText(readPokemon(pk4Addr)) or "No Mew/Phione offer running"

 SetScreenText(string.format("Initial Seed: %08X\nCurrent Seed: %08X\nAdvances: %d\n\n%s",
                             initialSeed, currentSeed, advances, offerText))
end

function onScriptCancel()
 SetScreenText("")
end

function onStateLoaded()
end

function onStateSaved()
end
