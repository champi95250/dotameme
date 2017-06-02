BAREBONES_VERSION = "1.00"
BAREBONES_DEBUG_SPEW = false 
LinkLuaModifier( "modifier_brawl", "modifier_but/modifier_brawl.lua" ,LUA_MODIFIER_MOTION_NONE )

_G.vip_members = {
	110786327,	-- MechJesus (Friend)1
	42452574,	-- FrenchDeath (Friend)2
	59765927,	-- Champi (ME :D )3
	28496872,	-- Ou Sen (Friend)4
	134026389,	-- Hypérion (Friend)5
	54896080,	-- Cookies (Friend)6
	43305444,	-- Baumi( Because why not? )7
	80027579,	-- JOKO (Friend) [U:1:80027579]8
	29129859,	-- Guiamuve (Friend)9
	158581004,	-- Shiroune Friend10
	129031445,	-- Trungk11
	88064214,	-- Hearen
	98883570,	-- Sean Gollum
	89498388	-- Sly
}

_G.pseudo = {
	"MechJesus",		-- MechJesus (Friend)1
	"Sexus",			-- FrenchDeath (Friend)2
	"GayLord Champi",	-- Champi (ME :D )3
	"Ou Sen Ben Laden",	-- Ou Sen (Friend)4
	"Hypércon",			-- Hypérion (Friend)5
	"Cookie$",			-- Cookies (Friend)6
	"Baumi",			-- Baumi( Because why not? )7
	"Feedoloaz",		-- JOKO (Friend) [U:1:80027579]8
	"Putamauve",		-- Guiamuve (Friend)9
	"Catmancer",		-- Shiroune Friend10
	"TK",				-- Trungk11
	"Hearen",			-- Hearen
	"LE PETIT PD",		-- Sean Gollum
	"Slyp"				-- Sly
}

if GameMode == nil then
	DebugPrint( '[BAREBONES] creating barebones game mode' )
	_G.GameMode = class({})
end

require('libraries/timers')
require('libraries/physics')
require('libraries/projectiles')
require('libraries/notifications')
require('libraries/animations')
require('libraries/attachments')
require('libraries/playertables')
require('libraries/containers')
require('libraries/modmaker')
require('libraries/pathgraph')
require('libraries/selection')
require('utility_functions')
require('internal/gamemode')
require('internal/events')
require('settings')
require('events')
require('gold')
require('custom_rune')

function GameMode:PostLoadPrecache()
	DebugPrint("[BAREBONES] Performing Post-Load precache")    
	--PrecacheItemByNameAsync("item_example_item", function(...) end)

	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
end

function GameMode:OnFirstPlayerLoaded()
	DebugPrint("[BAREBONES] First Player has loaded")
end

function GameMode:OnAllPlayersLoaded()
	DebugPrint("[BAREBONES] All Players have loaded into the game")
	if GameSettings.all_random > 0 and GameSettings.all_random_sh == 0 then
	print("All Random Activé")
		for player_id = 0, 15 do
			if PlayerResource:IsImbaPlayer(player_id) then
				PlayerResource:GetPlayer(player_id):MakeRandomHeroSelection()
				PlayerResource:SetCanRepick(player_id, false)
				PlayerResource:SetHasRandomed(player_id)
			end
		end
	end	
	if GameSettings.all_random_sh > 0 then
	--print("All Random Same hero Activé")
	--	for player_id = 0, 15 do
	--		if PlayerResource:IsImbaPlayer(player_id) then
	--			PlayerResource:GetPlayer(player_id):MakeRandomHeroSelection()
	--			PlayerResource:SetCanRepick(player_id, false)
	--			PlayerResource:SetHasRandomed(player_id)
	--			PlayerResource:ReplaceHeroWith(player_id, "npc_dota_hero_sven", 750, 0)
	--		end
	--	end
	end	
end

function GameMode:OnHeroInGame(hero)
	DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
end

function GameMode:OnGameInProgress()
	DebugPrint("[BAREBONES] The game has officially begun")

	for i = 1, 4 do
		local DoorObs = Entities:FindAllByName("obstruction_mid"..i)
		local DoorObs2 = Entities:FindAllByName("door_trap"..i)
		for _, obs in pairs(DoorObs) do
			obs:SetEnabled(false, true)
		end
		for _, obs2 in pairs(DoorObs2) do
			obs2:SetEnabled(false, true)
		end
		DoEntFire("door_mid"..i, "SetAnimation", "gate_entrance002_open", 0, nil, nil)
		DoEntFire("door_ext"..i, "SetAnimation", "spike_open", 0, nil, nil)
	end
	GameMode:ThinkGoldDrop()
	GameMode:Thinkcustomrune()
end

function GameMode:InitGameMode()
	GameMode = self
	DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

	self:GatherAndRegisterValidTeams()

	GameRules:SetGoldTickTime(0.0) --This is not dota bitch
	GameRules:SetGoldPerTick(0.0) --This is not dota bitch
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetStrategyTime(0.0)
	GameRules:SetPreGameTime(13.0)
	if GetMapName() == "arena_solo" then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_5, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_6, 1)
	else
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 2)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 2)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 2)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 2)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 2)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 2)
	end

	GameRules.knockback = LoadKeyValues("scripts/kv/knockback.kv")

	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnNPCSpawned" ), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled" ), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(self, "OnItemPickUp"), self)

	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "FilterExecuteOrder"), self)
	CustomGameEventManager:RegisterListener("setting_change", Dynamic_Wrap(self, "OnSettingChange"))
	CustomGameEventManager:RegisterListener("setting_change_radio", Dynamic_Wrap(self, "OnRadioButtonChange"))
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)

	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( self, "GoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( self, "ExpFilter" ), self )
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( self, "BountyFilter" ), self )

	ListenToGameEvent('game_rules_state_change', function()
		local newState = GameRules:State_Get()
		if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
			local heroes = HeroList:GetAllHeroes()
			local point = Entities:FindByName(nil, "hero_selection_camera")
			for _, hero in pairs(heroes) do
				PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), point:GetAbsOrigin())
			end
		elseif newState == 7 then
			if GameSettings.brawl > 0 then
				local brawler = CreateModifierThinker(nil,nil,"modifier_brawl",{},Vector(-10000,0,0),20,false)
			end
		end
	end, nil)

	for k,v in pairs( GameSettings ) do
		CustomNetTables:SetTableValue( "settings", k, { value = v } )
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#DOTA_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#DOTA_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#DOTA_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#DOTA_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#DOTA_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#DOTA_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#DOTA_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#DOTA_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#DOTA_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#DOTA_Custom8"

	DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

--	print( "Final shuffled team list:" )
--	for _, team in pairs( self.m_GatheredShuffledTeams ) do
--		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
--	end

--	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
--		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

function GameMode:OnThink( event )
	local player_id = event.PlayerID
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Game In Progress" )
		--EmitGlobalSound("Mlg.start_game")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		print( "Post game" )
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if GameSettings.mlg_sound > 0 then
			local random_start_sound = RandomInt(1, 3) 
			print(random_start_sound)
			EmitGlobalSound("Mlg.start_game_" .. random_start_sound)
			return 30
		end
	end
	return 1
end

function GameMode:BountyFilter( event )
	event.gold_bounty = event.gold_bounty * ( GameSettings.mult_gold * 0.01 )
	event.xp_bounty = event.xp_bounty * ( GameSettings.mult_exp * 0.01 )
	
	return true
end

function GameMode:GoldFilter( event )
	if GameSettings.mult_gold <= 0 then
		return false
	end
	
	event.gold = event.gold * ( GameSettings.mult_gold * 0.01 )
	
	return true
end

function GameMode:ExpFilter( event )
	if GameSettings.mult_exp <= 0 then
		return false
	end

	event.experience = event.experience * ( GameSettings.mult_exp * 0.01 )

	return true
end

function GameMode:FilterExecuteOrder( filterTable )
--for k, v in pairs( filterTable ) do
--	print("Order: " .. k .. " " .. tostring(v) )
--end

local units = filterTable["units"]
local order_type = filterTable["order_type"]
local issuer = filterTable["issuer_player_id_const"]
local abilityIndex = filterTable["entindex_ability"]
local targetIndex = filterTable["entindex_target"]
local x = tonumber(filterTable["position_x"])
local y = tonumber(filterTable["position_y"])
local z = tonumber(filterTable["position_z"])
local point = Vector(x,y,z)
local queue = filterTable["queue"] == 1

local unit
local numUnits = 0
local numBuildings = 0

	if not newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if units then
			-- Skip Prevents order loops
			unit = EntIndexToHScript(units["0"])
			if unit then
				if unit.skip then
					unit.skip = false
					return true
				end
			end

			for n,unit_index in pairs(units) do
				local unit = EntIndexToHScript(unit_index)
				if unit and IsValidEntity(unit) then
					unit.current_order = order_type -- Track the last executed order
					unit.orderTable = filterTable -- Keep the whole order table, to resume it later if needed
--					local bBuilding = IsCustomBuilding(unit) and not IsUprooted(unit)
--					if bBuilding then
--						numBuildings = numBuildings + 1
--					else
--						numUnits = numUnits + 1
--					end
				end
			end
		end

		if order_type == DOTA_UNIT_ORDER_RADAR or order_type == DOTA_UNIT_ORDER_GLYPH then return end

		if order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
			local ability = EntIndexToHScript(abilityIndex)
			local position = unit:GetAbsOrigin()
			local nearby_entities = Entities:FindAllByNameWithin("npc_dota_hero_*", position, 350000) -- test 1
			if not ability then return true end
			local playerID = unit:GetPlayerOwnerID()
			local machala = false

			local Trumpinate = ability:GetName() == "trump_assasinate"
			if Trumpinate then
				for _,v in pairs(nearby_entities) do
					if v:HasModifier("modifier_track_datadriven") and v:GetTeamNumber() ~= unit:GetTeamNumber() then -- Condition sous laquelle le spell ne se lance pas, en ajoutant un message d'erreur dans addon_english.txt nommé error_no_tracked_units
						print(v:GetName())
						machala = true
					end
				end
				if machala == false then
					SendErrorMessage(issuer, "#error_trumpinate")
					return false
				end
			end
		end

		if order_type == DOTA_UNIT_ORDER_CAST_POSITION then
			local ability = EntIndexToHScript(abilityIndex)
			local target = EntIndexToHScript(targetIndex)
			local Position = point
--			local playerID = unit:GetPlayerOwnerID()

			local rickportal = ability:GetName() == "rick_portal_a" or ability:GetName() == "rick_portal_b"

			if rickportal then
				local target_location = Position
				if target_location.x > 3200 or target_location.x < -3200 then
					SendErrorMessage(issuer, "#portail_hors_zone")
					return false
				elseif target_location.y > 3200 or target_location.y < -3200 then
					SendErrorMessage(issuer, "#portail_hors_zone")
					return false
				end
			end
		end

		if order_type == DOTA_UNIT_ORDER_CAST_TARGET then
			local ability = EntIndexToHScript(abilityIndex)
			local target = EntIndexToHScript(targetIndex)
--			local playerID = unit:GetPlayerOwnerID()

			if target:GetTeam() ~= unit:GetTeam() then
				if target:TriggerSpellAbsorb(ability) then
					local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
					local mana_set = ability:GetManaCost(ability:GetLevel() - 1)
					ability:StartCooldown(cooldown * GetCooldownReduction(unit))
					unit:SetMana(unit:GetMana() - mana_set)
					return
				end
			end
		end
	end

	return true
end
