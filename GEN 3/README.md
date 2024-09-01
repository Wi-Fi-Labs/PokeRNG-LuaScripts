# Gen 3
## RS/FRLG/E
* RNG Info
* Wild/Static/Gift Info
* 100% Catch RNG
* Breeding RNG
* Initial Seed Bot (FRLG)
* TID Bot (FRLG/E)
* IDs RNG
* Pokémon Info (Party/Box)
* IDs Info
* Other Misc RSE (Pokérus RNG / Lottery RNG / Mirage Island RNG / Feebas Tile Checker)

The main scripts for each game provided in the respective emulator folders have various modes you can cycle through, showcasing the most varied information for all kinds of RNG. The modes are titled appropriately depending on the type of RNG they are aimed at
* Edited versions of the BizHawk scripts by SexyMalasada with the suffix `_SM` are provided which have a better layout than the originals by Real96 - **They require a 3x Window size to display properly!** The original ones are still included in a folder named `Real96 OG Scripts`. 
* These pictures show the differences in the layout for [Bizhawk](https://github.com/SexyMalasada/PokeRNG-LuaScripts/blob/main/GEN%203/BizHawk/G3BizhawkLayout.png)
* Several Misc RSE RNG scripts are also included in the folder 'Side'. These are VBA only

## IMPORTANT!
* [VBA 23.6 RR 480-LRC4](https://github.com/TASEmulators/vba-rerecording/releases/tag/480LRC4) version required for VBA scripts
* [Bizhawk 2.8 rc-1](https://github.com/TASEmulators/BizHawk/releases/tag/2.8-rc1) required - _scripts in the `Older Scripts` folder require stable [Bizhawk 2.8](https://github.com/TASEmulators/BizHawk/releases/tag/2.8) instead_ for BizHawk scripts
* [mGBA 0.10.3](https://mgba.io/downloads.html) is required for mGBA scripts
* [Dolphin Lua-core](https://github.com/Real96/Dolphin-Lua-Core) is required for GCN scripts

## FRLG Initial Seed Bot Instructions
Due to the rapidly advancing method of generation of Initial Seeds in these games, a Bot that cycles for a desired Initial Seed is provided

To use it start by opening the script and editing it with your desired Initial Seeds at ``local botTargetInitSeeds =`` in hexadecimal values (preceded by 0x)

After that open your game, load the script and navigate to the Initial Seed Mode. Once you're at the 'Press Start' screen follow the on-screen script instructions to start the bot

## FRLG/E TID Bot Instructions
Due to the rapidly advancing method of generation of TID in these games, a Bot that cycles for a desired Trainer ID is provided

To use it start by opening the script and editing it with your desired Initial Seeds at ``local botTargetTIDs =`` in decimal values

After that open your game, load the script and navigate to the TID Bot Mode. Make your way through the 'New Game' dialogue until you're at the screen where you name your character. After you've given yourself a name, hover with the cursor on the 'END' option; once there follow the on-screen script instructions to start the bot


## Colosseum/XD
* Opponent Trainer/Gift RNG
* 100% Catch RNG
* [Mt. Battle Ho-Oh](https://devonstudios.it/2021/05/22/colosseum-mt-battle-ho-oh/) (C) RNG
* [e-Reader](https://devonstudios.it/2021/04/29/colosseum-e-reader-shadows/) (C) RNG
* [IDs](https://devonstudios.it/2021/03/17/colosseum-ids/) (C) / [IDs](https://devonstudios.it/2021/05/30/xd-ids/) (G) RNG
* RNG Info
* Pokémon Info
* IDs Info
* Ageto Celebi RNG
* Channel Jirachi RNG
* RS Box RNG

The scripts provided here for each game showcase the most varied information that you require for each type of RNG.
* Dolphin Lua-Core version is required

### Credits
Source repos [DevonStudios](https://github.com/DevonStudios/LuaScripts/tree/main/Gen%203) &amp; [Real96](https://github.com/Real96/PokeLua/tree/main/Gen%203). Scripts by Real96