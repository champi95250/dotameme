LinkLuaModifier( "modifier_souls", "modifier_but/modifier_souls.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_souls_agility", "modifier_but/modifier_souls_agility.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_souls_strength", "modifier_but/modifier_souls_strength.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_souls_int", "modifier_but/modifier_souls_int.lua" ,LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_attack_counter", "modifier_but/modifier_attack_counter.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attack_spells", "modifier_but/modifier_attack_spells.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ryze", "modifier_but/modifier_ryze.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_branches", "modifier_but/modifier_branches.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mlg_sound", "modifier_but/modifier_mlg_sound.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_brawl", "modifier_but/modifier_brawl.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_denied", "modifier_but/modifier_denied.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_river", "modifier_but/modifier_river.lua" ,LUA_MODIFIER_MOTION_NONE )

function GameMode:OnSettingChange(event)
local setting = event.setting
local value = tonumber(event.value)

	print("Setting Change: ", setting, value)
	CustomNetTables:SetTableValue("settings", setting, {value = value})
	GameSettings[setting] = value
end

function GameMode:OnRadioButtonChange(event)
local setting = event.setting
local value = tonumber(event.value)

	print("Setting Change: ", setting, value)
	CustomNetTables:SetTableValue("settings", setting, {value = value})
	GameSettings[setting] = value
end

gamestates = {
	[0] = "DOTA_GAMERULES_STATE_INIT",
	[1] = "DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD",
	[2] = "DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP",
	[3] = "DOTA_GAMERULES_STATE_HERO_SELECTION",
	[4] = "DOTA_GAMERULES_STATE_STRATEGY_TIME",
	[5] = "DOTA_GAMERULES_STATE_TEAM_SHOWCASE",
	[6] = "DOTA_GAMERULES_STATE_PRE_GAME",
	[7] = "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS",
	[8] = "DOTA_GAMERULES_STATE_POST_GAME",
	[9] = "DOTA_GAMERULES_STATE_DISCONNECT"
}

function GameMode:OnDisconnect(keys)
	DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DebugPrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	print("[BotM] GameRules State Changed: ",gamestates[newState])

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Timers:CreateTimer(HERO_SELECTION_TIME, function()
			for i = 0, DOTA_MAX_TEAM_PLAYERS do
				if PlayerResource:IsValidPlayer(i) then
					if PlayerResource:HasSelectedHero(i) == false then
						local player = PlayerResource:GetPlayer(i)
						player:MakeRandomHeroSelection()
					end
				end
			end
		end)
	elseif newState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		CustomNetTables:SetTableValue("game_state", "victory_condition", {value = GameSettings.max_kills});
		CustomNetTables:SetTableValue("game_state", "brawl", {value = GameSettings.brawl});
		CustomNetTables:SetTableValue("game_state", "attack_allie", {value = GameSettings.attack_allie});
		CustomNetTables:SetTableValue("game_state", "aghanim", {value = GameSettings.aghanim});
		CustomNetTables:SetTableValue("game_state", "multicast", {value = GameSettings.multicast});
		CustomNetTables:SetTableValue("game_state", "mult_gold", {value = GameSettings.mult_gold});
		CustomNetTables:SetTableValue("game_state", "mult_exp", {value = GameSettings.mult_exp});
		for i = 1, 11 do
			AddFOWViewer(i, Vector(0, 0, 0), 1600, 9999, false)
		end
	end
end

function GameMode:OnNPCSpawned(event)
	DebugPrint("[BAREBONES] NPC Spawned")
	DebugPrintTable(event)

	local npc = EntIndexToHScript(event.entindex)
	local unitName = npc:GetUnitName()
	local ability = npc:GetAbilityByIndex(0)
	
	if unitName == "npc_dota_thinker" or unitName == "npc_dota_companion" then
		return
	end	

	if npc:IsRealHero() then
		if not npc:IsClone() then
			if GameSettings.multicast > 0 and not npc:HasAbility("multi_cast_ability") then
				local multicast = npc:AddAbility("multi_cast_ability")
				multicast:SetLevel(1)
			end
			if GameSettings.hero_branches > 0 then
				npc:AddNewModifier( npc, nil, "modifier_branches", {} )
			end
		end
		if GameSettings.attack_allie > 0 then
			npc:AddNewModifier( npc, nil, "modifier_denied", {} )
		end
		if GameSettings.aghanim > 0 and not npc:HasModifier("modifier_item_ultimate_scepter_consumed") then
			npc:AddNewModifier(npc, ability, "modifier_item_ultimate_scepter_consumed", {})
		end
		if GameSettings.mlg_sound > 0 then
			npc:AddNewModifier( npc, nil, "modifier_mlg_sound", {} )
		end
	end

	if GameSettings.kill_soul > 0 then
		npc:AddNewModifier( npc, nil, "modifier_souls", {} )
	end
	if GameSettings.kill_soul_agility > 0 then	
		npc:AddNewModifier( npc, nil, "modifier_souls_agility", {} )
	end
	if GameSettings.kill_soul_strength > 0 then	
		npc:AddNewModifier( npc, nil, "modifier_souls_strength", {} )
	end
	if GameSettings.kill_soul_int > 0 then	
		npc:AddNewModifier( npc, nil, "modifier_souls_int", {} )
	end
	if GameSettings.cast_instantly > 0 then
		npc:AddNewModifier( npc, nil, "modifier_attack_spells", {} )
	end
	if GameSettings.cast_is_touch > 0 then
		npc:AddNewModifier( npc, nil, "modifier_attack_counter", {} )
	end
	if GameSettings.reduce_cd > 0 then
		npc:AddNewModifier( npc, nil, "modifier_ryze", {} )
	end

	if GameSettings.brawl > 0 then
		-- npc:AddNewModifier( npc, nil, "modifier_brawl", {} )
		if not npc.hasPhysics then
			Physics:Unit(npc)
			npc:SetPhysicsFriction (0.05)
			npc:SetPhysicsVelocityMax (3500)
			npc:SetGroundBehavior (PHYSICS_GROUND_NONE)
			npc:SetNavCollisionType (PHYSICS_NAV_BOUNCE)
			npc:SetBounceMultiplier(0.8)
			npc:SetAutoUnstuck(true)
			npc:FollowNavMesh(true)
			npc.hasPhysics = true

			if npc:IsHero() then
				--npc:AddNewModifier(nil,nil,"modifier_brawl_min_health",{Duration})
			end
		end
	npc:SetPhysicsVelocity(Vector(0,0,0))
		npc:SetPhysicsAcceleration(Vector(0,0,0))
	end

	if ( GameSettings.river_heal + GameSettings.river_irradiated + GameSettings.river_ice ) > 0 and not npc:IsCourier() then
		npc:AddNewModifier( npc, nil, "modifier_river", {} )
	end

	for i = 1, #vip_members do
		if npc:IsRealHero() then
			if PlayerResource:GetSteamAccountID(npc:GetPlayerID()) == vip_members[i] then
				local playerID = npc:GetPlayerID()
				local player = PlayerResource:GetPlayer(playerID)
				npc:SetCustomHealthLabel("VIP " .. pseudo[i], 218, 165, 32)
				if not npc:HasAbility("vip_ability") then
					local vip_ability = npc:AddAbility("vip_ability")
					vip_ability:SetLevel(1)
				end
			end
		end
	end
end

-- SMASH BROS PARTI
function CDOTABaseAbility:HasKnockbackMultiplier()
	if GameRules.knockback["knockback_multiplier"][self:GetAbilityName()] then
		return true
	else
		return false
	end
end

function CDOTABaseAbility:HasBaseKnockbackValue()
	if GameRules.knockback["knockback_base"][self:GetAbilityName()] then
		return true
	else
		return false
	end
end

function CDOTABaseAbility:GetKnockbackMultiplier()
	return GameRules.knockback["knockback_multiplier"][self:GetAbilityName()] 
end

function CDOTABaseAbility:GetBaseKnockbackValue()
	return GameRules.knockback["knockback_base"][self:GetAbilityName()] 
end

function GameMode:OnEntityHurt(keys)
	--DebugPrint("[BAREBONES] Entity Hurt")
	--DebugPrintTable(keys)

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
		local entCause = EntIndexToHScript(keys.entindex_attacker)
		local entVictim = EntIndexToHScript(keys.entindex_killed)

		-- The ability/item used to damage, or nil if not damaged by an item/ability
		local damagingAbility = nil

		if keys.entindex_inflictor ~= nil then
			damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
		end
	end
end

function GameMode:OnItemPickedUp(keys)
	DebugPrint( '[BAREBONES] OnItemPickedUp' )
	DebugPrintTable(keys)

	local unitEntity = nil
	if keys.UnitEntitIndex then
		unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

function GameMode:OnPlayerReconnect(keys)
	DebugPrint( '[BAREBONES] OnPlayerReconnect' )
	DebugPrintTable(keys) 
end

function GameMode:OnItemPurchased( keys )
	DebugPrint( '[BAREBONES] OnItemPurchased' )
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
end

function GameMode:OnAbilityUsed(keys)
	DebugPrint('[BAREBONES] AbilityUsed')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

function GameMode:OnNonPlayerUsedAbility(keys)
	DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	DebugPrintTable(keys)

	local abilityname=  keys.abilityname
end

function GameMode:OnPlayerChangedName(keys)
	DebugPrint('[BAREBONES] OnPlayerChangedName')
	DebugPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

function GameMode:OnPlayerLearnedAbility( keys)
	DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

function GameMode:OnAbilityChannelFinished(keys)
	DebugPrint('[BAREBONES] OnAbilityChannelFinished')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

function GameMode:OnPlayerLevelUp(keys)
	DebugPrint('[BAREBONES] OnPlayerLevelUp')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level
	local levels_without_ability_point = {17, 19, 21, 22, 23, 24}
	
	for i = 1, #levels_without_ability_point do
		if level == levels_without_ability_point[i] then
			local hero = player:GetAssignedHero()
			local unspent_ability_points = hero:GetAbilityPoints()
			hero:SetAbilityPoints(unspent_ability_points+1)
		end
	end
end

function GameMode:OnLastHit(keys)
	DebugPrint('[BAREBONES] OnLastHit')
	DebugPrintTable(keys)

	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)
end

function GameMode:OnTreeCut(keys)
	DebugPrint('[BAREBONES] OnTreeCut')
	DebugPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

function GameMode:OnRuneActivated(keys)
	DebugPrint('[BAREBONES] OnRuneActivated')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

function GameMode:OnPlayerTakeTowerDamage(keys)
	DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

function GameMode:OnPlayerPickHero(keys)
	DebugPrint('[BAREBONES] OnPlayerPickHero')
	DebugPrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
end

function GameMode:OnTeamKillCredit(keys)
DebugPrint('[BAREBONES] OnTeamKillCredit')
DebugPrintTable(keys)

local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
local numKills = keys.herokills
local killerTeamNumber = keys.teamnumber

	if numKills >= GameSettings.max_kills then
		GameRules:SetCustomVictoryMessage(self.m_VictoryMessages[killerTeamNumber].." #VictoryMessage")
		print(self.m_VictoryMessages[killerTeamNumber].."#VictoryMessage")
		GameRules:SetGameWinner(killerTeamNumber)
	end
end

function GameMode:OnEntityKilled( keys )
	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
	DebugPrintTable( keys )

	local heroes = HeroList:GetAllHeroes()
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = nil
	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end
	local numKills = GetTeamHeroKills(killerEntity:GetTeam())

	local killerAbility = nil
	if keys.entindex_inflictor ~= nil then
		killerAbility = EntIndexToHScript( keys.entindex_inflictor )
	end

	if killedUnit ~= nil and killedUnit:IsRealHero() then
		print("Hero Dead")
		killedUnit:SetTimeUntilRespawn( killedUnit:GetLevel() * 1.25 )--* ( GameSettings.mult_respawn * 0.01 )
		if numKills * 3 >= GameSettings.max_kills and GameSettings.multicast == 1 then
			GameSettings.multicast = 2
			CustomNetTables:SetTableValue("game_state", "multicast", {value = GameSettings.multicast});
			Notifications:TopToAll({text="Multicast is now level 2!", style={color="DodgerBlue"}, duration=5.0})
			EmitGlobalSound("ogre_magi_ogmag_thanks_01")
			EmitGlobalSound("Hero_OgreMagi.Ignite.Target")
			print("MULTICAST: "..GameSettings.multicast)
			for _, hero in pairs(heroes) do
				local multicast = hero:FindAbilityByName("multi_cast_ability")
				if hero:HasAbility("multi_cast_ability") then
					multicast:SetLevel(2)
				end
			end
		elseif numKills * 2 >= GameSettings.max_kills and GameSettings.multicast == 2 then
			GameSettings.multicast = 3
			CustomNetTables:SetTableValue("game_state", "multicast", {value = GameSettings.multicast});
			Notifications:TopToAll({text="Multicast is now level 3!", style={color="DodgerBlue"}, duration=5.0})
			EmitGlobalSound("ogre_magi_ogmag_thanks_01")
			EmitGlobalSound("Hero_OgreMagi.Ignite.Target")
			print("MULTICAST: "..GameSettings.multicast)
			for _, hero in pairs(heroes) do
				local multicast = hero:FindAbilityByName("multi_cast_ability")
				if hero:HasAbility("multi_cast_ability") then
					multicast:SetLevel(3)
				end
			end
		elseif numKills * 1.5 >= GameSettings.max_kills and GameSettings.multicast == 3 then
			GameSettings.multicast = 4
			CustomNetTables:SetTableValue("game_state", "multicast", {value = GameSettings.multicast});
			Notifications:TopToAll({text="Multicast is now level 4!", style={color="DodgerBlue"}, duration=5.0})
			EmitGlobalSound("ogre_magi_ogmag_thanks_01")
			EmitGlobalSound("Hero_OgreMagi.Ignite.Target")
			print("MULTICAST: "..GameSettings.multicast)
			for _, hero in pairs(heroes) do
				local multicast = hero:FindAbilityByName("multi_cast_ability")
				if hero:HasAbility("multi_cast_ability") then
					multicast:SetLevel(4)
				end
			end
		end
	end
	local damagebits = keys.damagebits -- This might always be 0 and therefore useless
end

function GameMode:PlayerConnect(keys)
	DebugPrint('[BAREBONES] PlayerConnect')
	DebugPrintTable(keys)
end

function GameMode:OnConnectFull(keys)
	DebugPrint('[BAREBONES] OnConnectFull')
	DebugPrintTable(keys)
	
	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	local player_id = ply:GetPlayerID()
	
	PlayerResource:InitPlayerData(player_id)
	
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()
end

function GameMode:OnIllusionsCreated(keys)
	DebugPrint('[BAREBONES] OnIllusionsCreated')
	DebugPrintTable(keys)

	local originalEntity = EntIndexToHScript(keys.original_entindex)
end

function GameMode:OnItemCombined(keys)
	DebugPrint('[BAREBONES] OnItemCombined')
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

function GameMode:DamageFilter( event )
	local victim = EntIndexToHScript( event.entindex_victim_const )
	local attacker = EntIndexToHScript( event.entindex_attacker_const )
	
	return true
end

function GameMode:OnAbilityCastBegins(keys)
	DebugPrint('[BAREBONES] OnAbilityCastBegins')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

function GameMode:OnTowerKill(keys)
	DebugPrint('[BAREBONES] OnTowerKill')
	DebugPrintTable(keys)

	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local team = keys.teamnumber
end

function GameMode:OnPlayerSelectedCustomTeam(keys)
	DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

function GameMode:OnNPCGoalReached(keys)
	DebugPrint('[BAREBONES] OnNPCGoalReached')
	DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end

function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text
end
