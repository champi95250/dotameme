function trump_hurle(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local tPlayerID = target:GetPlayerID()
	
	if GetMapName() == "dota" then
		if PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_GOODGUYS then
			ability.point_position = Vector(-7286, -6782, 1494)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_BADGUYS then
			ability.point_position = Vector(7030, 6560, 0)
		end
	end
	
	if GetMapName() == "arena_solo" then
		if PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_GOODGUYS then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_BADGUYS then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_1 then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_2 then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_3 then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_4 then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_5 then
			ability.point_position = Vector(0, 0, 0)
		elseif PlayerResource:GetTeam(tPlayerID) == DOTA_TEAM_CUSTOM_6 then 
			ability.point_position = Vector(0, 0, 0)
		end
	end

	print(ability.point_position)
	local order_target = 
	{
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = ability.point_position
	}
	target:Stop()
	ExecuteOrderFromTable(order_target)
	

	--caster:AddNewModifier(caster, ability, "modifier_link_triforce_slash_lua", {Duration = 0.5})
	--ability:ApplyDataDrivenModifier(caster, caster, modifier_duel, {Duration = keys.Duration})
end