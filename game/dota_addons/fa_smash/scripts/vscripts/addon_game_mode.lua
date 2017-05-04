-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require('game_settings')
require('player_resource')

function Precache( context )
	DebugPrint("[BAREBONES] Performing pre-load precache")

	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_bounty_hunter", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_ogre_magi", context)
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	PrecacheUnitByNameSync("npc_dota_hero_tusk", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:_InitGameMode()
end
