-- Lvlup des portails

function LevelUpAbility( event ) 
	local caster = event.caster -- Caster
	local this_ability = event.ability	
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_name_2 = event.ability_name_2
	local ability_name_3 = event.ability_name_3

	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_handle_2 = caster:FindAbilityByName(ability_name_2)
	local ability_handle_3 = caster:FindAbilityByName(ability_name_3)

	local ability_level = ability_handle:GetLevel()
	local ability_level_2 = ability_handle_2:GetLevel()
	local ability_level_3 = ability_handle_3:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
	if ability_level_2 ~= this_abilityLevel then
		ability_handle_2:SetLevel(this_abilityLevel)
	end
	if ability_level_3 ~= this_abilityLevel then
		ability_handle_3:SetLevel(this_abilityLevel)
	end
end

-- Retour des capacité
function stop( event )
	local caster = event.caster
	local ability = event.ability
	local main_ability_name = ability:GetAbilityName()
	local sub_ability_name = event.sub_ability_name

	caster.swap = false

	-- Destruction du portail A
	if caster.dummy:IsNull() == false then
		ParticleManager:DestroyParticle( caster.dummy.teleportParticle, false )
		ParticleManager:ReleaseParticleIndex( caster.dummy.teleportParticle )
		caster.dummy:ForceKill(true)
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

	caster.dummy = CreateUnitByName( "npc_dummy_unit", point, false, caster, nil, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, caster.dummy, "modifier_aura_teleport", {} )
	ability:ApplyDataDrivenModifier( caster, caster.dummy, "modifier_dummy_portal", {} )
	caster.dummy:AddNewModifier(caster, ability, "modifier_kill", {duration = duration_portal})

	local particleName = "particles/rick/portal_a.vpcf"
	caster.dummy.teleportParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster.dummy)
	ParticleManager:SetParticleControl(caster.dummy.teleportParticle, 1, caster.dummy:GetAbsOrigin()) 
	print("Abilité A :" .. abilityName)
	print("Abilité B :" .. sub_ability_name)

	caster.swap = true

	

	Timers:CreateTimer(0.5, function() 
		local cd = ability:GetCooldownTimeRemaining()
		time = time + 0.5
		if caster.swap == true and time == duration_portal then
			caster:SwapAbilities( abilityName, sub_ability_name, true, false )
			ParticleManager:DestroyParticle( caster.dummy.teleportParticle, false )
			ParticleManager:ReleaseParticleIndex( caster.dummy.teleportParticle )
			caster.swap = false
			return false
		elseif caster.swap == false and time <= duration_portal and cd <= 2.6 then
			ability:EndCooldown()
			ability:StartCooldown(0.5)
			return 0.5
		elseif caster.swap == false and time >= duration_portal and cd <= 2.6 then
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
	
	--if caster.dummy_2:IsNull() == false then
		if caster.swap2 == true then
			local position_dummy = caster.dummy_2:GetAbsOrigin()
			if not target:HasModifier("modifier_no_teleport_b") or not target:HasModifier("modifier_no_teleport_a") then
				print("teleport ok")
				GridNav:DestroyTreesAroundPoint( position_dummy, 250, false )
				target:SetAbsOrigin(position_dummy)
				FindClearSpaceForUnit( target, position_dummy, true )
				target:Interrupt()
			end
		elseif caster.swap2 == false then
			print("cannot tp")
			SendErrorMessage(player_ID, "#error_portal")
		elseif caster.swap2:IsNull() == true then
			SendErrorMessage(player_ID, "#error_portal")
		end
	--end
	
end


-- caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )