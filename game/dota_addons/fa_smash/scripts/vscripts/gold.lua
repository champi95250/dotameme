function GameMode:ThinkGoldDrop()
	Timers:CreateTimer(0.0, function()
		local r = RandomInt( 1, 100 )
		if r > ( 100 - 42 ) then
			print("spawn")
			GameMode:SpawnGold()
		end
		return 5
	end)
end

function GameMode:SpawnGold()
	self:SpawnGoldEntity( Vector( 0, 0, 0 ) )
end

function GameMode:SpawnGoldEntity( spawnPoint )
--	EmitSoundOn("Item.PickUpGemWorld", spawnPoint)
	local r = RandomInt( 1, 100 )
	print("random item:" .. r)
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	if r > 15 then
		print("oka")
		newItem = CreateItem( "item_bag_of_gold", nil, nil )
	else
		print("okb")
		newItem = CreateItem( "item_bag_of_gold_ixtra", nil, nil )
	end
	
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 30, 450 )
	newItem:LaunchLootInitialHeight( false, 0, 350, 0.75, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 25 )

end

function GameMode:KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	--EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end
