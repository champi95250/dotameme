LinkLuaModifier("modifier_armor", "runes/modifier_armor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_regen", "runes/modifier_regen.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_modifier_runee_invis_fade", "runes/modifier_runee_invis.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_modifier_runee_invis", "runes/modifier_runee_invis.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_mushroom", "runes/modifier_rune_mushroom.lua", LUA_MODIFIER_MOTION_NONE)


function GameMode:Thinkcustomrune()
	Timers:CreateTimer(0.0, function()
		GameMode:SpawnRune()
		return 60.0
	end)
end

function GameMode:SpawnRune()
	for i = 1, 4 do
		local powerup_rune_spawner = Entities:FindAllByName("dota_item_rune_spawner"..i)
		local powerup_rune_position = powerup_rune_spawner[1]:GetAbsOrigin()
		self:SpawnRuneEntity( powerup_rune_position )
	end
end

function GameMode:SpawnRuneEntity( spawnPoint )
--	EmitSoundOn("Item.PickUpGemWorld", spawnPoint)
	local r = RandomInt( 1, 6 )
	-- Liste des Runes
	gamerunes = {
	[0] = "item_rune_haste",
	[1] = "item_rune_haste",
	[2] = "item_rune_double_damage",
	[3] = "item_rune_invis",
	[4] = "item_rune_armor",
	[5] = "item_rune_healing",
	[6] = "item_rune_grow"
	}
	-- Liste des runes : 
	-- 1 - Haste ( 100% MS Durée 30 Secondes )
	-- 2 - Double Damage / Magique ( +100% Damage +50% Magique )
	-- 3 - Invisibility ( Durée 45 secondes )
	-- 4 - Armor ( +20 D'armure / 50% Magical Armor )
	-- 5 - Healing / Mana ( Restaura entierement le Mana / Vie )
	local item_choice = gamerunes[r]
	print(item_choice)

	local newItem = CreateItem( item_choice, nil, nil )
	-- CreateItemOnPositionForLaunch(spawnPoint, newItem)
	-- Animation :
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 0, 0 )
	newItem:LaunchLootInitialHeight( false, 0, 35, 0.5, spawnPoint )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 60 )
end

function GameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local itemname = event.itemname
	if event.HeroEntityIndex ~= nil then
        heroEntity = EntIndexToHScript(event.HeroEntityIndex)
        player = PlayerResource:GetPlayer(event.PlayerID)
	end
	print(event.itemname)
	print(owner:GetName())
	print(heroEntity)
	print(heroEntity:GetName())

	if event.itemname == "item_rune_haste" then -- ok ! 
		local duration = 25
		heroEntity:AddNewModifier(heroEntity, item, "modifier_rune_haste", {duration = duration})
		EmitSoundOnLocationForAllies(heroEntity:GetAbsOrigin(), "Rune.Haste", heroEntity)
		UTIL_Remove( item )
	elseif event.itemname == "item_rune_double_damage" then -- ok ! 
		local duration = 45
		heroEntity:AddNewModifier(heroEntity, item, "modifier_rune_doubledamage", {duration = duration})
		EmitSoundOnLocationForAllies(heroEntity:GetAbsOrigin(), "Rune.DD", heroEntity)
		UTIL_Remove( item )
	elseif event.itemname == "item_rune_invis" then
		local duration = 0.4
		owner:AddNewModifier(owner, item, "modifier_modifier_runee_invis_fade", {duration = 0.4})
		EmitSoundOnLocationForAllies(heroEntity:GetAbsOrigin(), "Rune.Haste", heroEntity)
		UTIL_Remove( item )
	elseif event.itemname == "item_rune_armor" then
		local duration = 30
		owner:AddNewModifier(owner, owner, "modifier_armor", {duration = duration})
		EmitSoundOnLocationForAllies(heroEntity:GetAbsOrigin(), "Rune.DD", heroEntity)
		--UTIL_Remove( item )
	elseif event.itemname == "item_rune_healing" then
		local duration = 30
		owner:AddNewModifier(owner, owner, "modifier_regen", {duration = duration})
		EmitSoundOnLocationForAllies(owner:GetAbsOrigin(), "Rune.Regen", owner)
		--UTIL_Remove( item )
	elseif event.itemname == "item_rune_grow" then
		local duration = 30
		owner:AddNewModifier(owner, owner, "modifier_rune_mushroom", {duration = duration})
		EmitSoundOnLocationForAllies(owner:GetAbsOrigin(), "Rune.DD", owner)
		--UTIL_Remove( item )
	end

	r = RandomInt(5, 200)
	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	--elseif event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		--DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		--COverthrowGameMode:SpecialItemAdd( event )
		--UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end

	r_extra = RandomInt(250, 750)
	if event.itemname == "item_bag_of_gold_ixtra" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r_extra, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r_extra, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	--elseif event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		--DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		--COverthrowGameMode:SpecialItemAdd( event )
		--UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end