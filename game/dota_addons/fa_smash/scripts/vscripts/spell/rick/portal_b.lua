-- Retour des capacité
function stop( event )
	local caster = event.caster
	local ability = event.ability
	local main_ability_name = ability:GetAbilityName()
	local sub_ability_name = event.sub_ability_name

	caster.swap2 = false

	-- Destruction du portail b
	if caster.dummy_2:IsNull() == false then
		ParticleManager:DestroyParticle( caster.dummy_2.teleportParticle, false )
		ParticleManager:ReleaseParticleIndex( caster.dummy_2.teleportParticle )
		caster.dummy_2:ForceKill(true)

	end
	
	-- Swap les capacités
	caster:SwapAbilities( sub_ability_name, main_ability_name, true, false )

end

function create( event )
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability
	local abilityName = ability:GetAbilityName()
	local sub_ability_name = event.ability_name
	local duration_portal = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local time = 0

	caster.dummy_2 = CreateUnitByName( "npc_dummy_unit", point, false, caster, nil, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, caster.dummy_2, "modifier_aura_teleport_2", {} )
	ability:ApplyDataDrivenModifier( caster, caster.dummy_2, "modifier_dummy_portal", {} )
	caster.dummy_2:AddNewModifier(caster, ability, "modifier_kill", {duration = duration_portal})
	print("Abilité A :" .. abilityName)
	print("Abilité B :" .. sub_ability_name)

	local particleName = "particles/rick/portal_a.vpcf"
	caster.dummy_2.teleportParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster.dummy_2)
	ParticleManager:SetParticleControl(caster.dummy_2.teleportParticle, 1, caster.dummy_2:GetAbsOrigin()) 

	caster.swap2 = true

	Timers:CreateTimer(0.5, function() 
		local cd = ability:GetCooldownTimeRemaining()
		-- print("CD :" .. cd)
		time = time + 0.5
		-- print("Time :" .. time)
		if caster.swap2 == true and time == duration_portal then
			caster:SwapAbilities( abilityName, sub_ability_name, true, false )
			ParticleManager:DestroyParticle( caster.dummy_2.teleportParticle, false )
			ParticleManager:ReleaseParticleIndex( caster.dummy_2.teleportParticle )
			caster.swap2 = false
			return false
		elseif caster.swap2 == false and time <= duration_portal and cd <= 2.6 then
			ability:EndCooldown()
			ability:StartCooldown(0.5)
			return 0.5
		elseif caster.swap2 == false and time >= duration_portal and cd <= 2.6 then
			ability:EndCooldown()
			return false
		end
		return 0.5
	end)

	caster:SwapAbilities( abilityName, sub_ability_name, false, true )
end

function teleport( event )
	local caster = event.caster
	local target = event.target
	local player_ID = caster:GetPlayerID()
	print("lancement")

	--if caster.dummy:IsNull() == false then
		if caster.swap == true then
			local position_dummy = caster.dummy:GetAbsOrigin()
			if not target:HasModifier("modifier_no_teleport_b") or not target:HasModifier("modifier_no_teleport_a") then
				print("teleport ok")
				GridNav:DestroyTreesAroundPoint( position_dummy, 250, false )
				target:SetAbsOrigin(position_dummy)
				FindClearSpaceForUnit( target, position_dummy, true )
				target:Interrupt()
			end
		elseif caster.swap == false then
			print("cannot tp")
			SendErrorMessage(player_ID, "#error_portal")
		elseif caster.swap:IsNull() == true then
			SendErrorMessage(player_ID, "#error_portal")
		end
	--end
	
end


-- caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )