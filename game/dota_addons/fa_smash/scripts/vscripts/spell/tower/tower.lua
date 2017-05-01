function Forgechange( keys )
	local caster = keys.caster
	print(caster:GetUnitName())
	local target = keys.target
	print(target:GetUnitName())
	local player = target:GetPlayerOwnerID()
	print(player)
	local ability = keys.ability
	
	
	caster:SetTeam(target:GetTeamNumber())
	caster:SetControllableByPlayer(player, true)
	caster:SetOwner(target)
	ability:SetActivated(false)
	--caster:RemoveAbility(ability)
	if target:GetTeamNumber() == 1 then
		caster:SetRenderColor(27, 192, 216)
	elseif target:GetTeamNumber() == 2 then
		caster:SetRenderColor(212, 50, 52)
	elseif target:GetTeamNumber() == 3 then
		caster:SetRenderColor(53, 201, 42)
	elseif target:GetTeamNumber() == 4 then
		caster:SetRenderColor(255, 108, 0)
	elseif target:GetTeamNumber() == 5 then
		caster:SetRenderColor(52, 85, 255)
	elseif target:GetTeamNumber() == 6 then
		caster:SetRenderColor(101, 212, 19)
	elseif target:GetTeamNumber() == 7 then
		caster:SetRenderColor(129, 83, 54)
	elseif target:GetTeamNumber() == 8 then
		caster:SetRenderColor(27, 192, 216)
	end
	
	Timers:CreateTimer(1, function()
		local units = FindUnitsInRadius( caster:GetTeam(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0 , 0, false )
		print("Relance le timer")
		if units:HasModifier("modifier_forge_change_team") then
			Return 1.0
		else
			ability:SetActivated(true)
		end
	end)


end