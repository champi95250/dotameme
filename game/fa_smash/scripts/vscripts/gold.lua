function GameMode:ThinkGoldDrop()

	local r = RandomInt( 1, 100 )
	if r > ( 100 - 42 ) then
		GameMode:SpawnGold()
	end
end

function GameMode:SpawnGold()
	self:SpawnGoldEntity( Vector( 0, 0, 0 ) )
end

function GameMode:SpawnGoldEntity( spawnPoint )
	EmitSoundOn("Item.PickUpGemWorld", spawnPoint)
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 40, 860 )
	newItem:LaunchLootInitialHeight( false, 0, 350, 0.75, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 20 )
end

function GameMode:KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function GameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	r = RandomInt(1, 200)
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
end
