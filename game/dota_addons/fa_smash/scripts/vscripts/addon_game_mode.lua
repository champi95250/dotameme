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

	PrecacheModel( "models/heroes/pedobear/pedobear.vmdl", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_bruce.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_catmancer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_jesus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_microphone.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_mlg.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_nyan.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_pedobear.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_sanic.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:_InitGameMode()
end
