function venomancer_plague_ward_datadriven_on_spell_start(keys)
	--The Plague Ward should initialize facing away from Venomancer, so find that direction.
	local caster = keys.caster
	local ability = keys.ability
	local caster_origin = keys.caster:GetAbsOrigin()
	local caster_points = keys.target_points[1]
	local direction = (keys.target_points[1] - caster_origin):Normalized()
	direction.z = 0
	local fv = caster:GetForwardVector()
	local scepter = HasScepter(caster)
	
	ang_right = QAngle(0, -25, 0)
	ang_left = QAngle(0, 25, 0)
	ang_up = QAngle(0, 0, 0)
	
	local front_position_1 = caster_points + fv * 100
	local front_position_2 = caster_points + fv * 100
	local front_position_3 = caster_points + fv * 200
	print(front_position_1)
	print(front_position_2)
	
	point_left = RotatePosition(caster_points, ang_left, front_position_1)
	point_right = RotatePosition(caster_points, ang_right, front_position_2)
	point_up = RotatePosition(caster_points, ang_up, front_position_3)
	print(point_left)
	print(point_right)
	print(point_up)
	
	keys.caster:EmitSound("Catmancer.ulti.Cast")
	keys.caster:EmitSound("Catmancer.ulti.Cast")
	keys.caster:EmitSound("Catmancer.ulti.Cast")
	
	local plague_ward_level = keys.ability:GetLevel()
	if plague_ward_level >= 1 and plague_ward_level <= 3 then
		local plague_ward_unit = CreateUnitByName("catmancer_" .. plague_ward_level .. "_datadriven", point_left, false, keys.caster, keys.caster, keys.caster:GetTeam())
		print("catmancer" .. plague_ward_level .. "_datadriven")
		plague_ward_unit:SetForwardVector(direction)
		plague_ward_unit:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
		plague_ward_unit:SetOwner(keys.caster)
		
		local plague_ward_unit_2 = CreateUnitByName("catmancer_" .. plague_ward_level .. "_datadriven", point_right, false, keys.caster, keys.caster, keys.caster:GetTeam())
		plague_ward_unit_2:SetForwardVector(direction)
		plague_ward_unit_2:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
		plague_ward_unit_2:SetOwner(keys.caster)
		
		if scepter then
			local plague_ward_unit_3 = CreateUnitByName("catmancer_" .. plague_ward_level .. "_datadriven", point_up, false, keys.caster, keys.caster, keys.caster:GetTeam())
			plague_ward_unit_3:SetForwardVector(direction)
			plague_ward_unit_3:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
			plague_ward_unit_3:SetOwner(keys.caster)
		end
		
		--Display particle effects for Venomancer as well as the plague ward.
		local venomancer_plague_ward_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_ABSORIGIN, keys.caster)
		local plague_ward_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN, plague_ward_unit)
		local plague_ward_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN, plague_ward_unit_2)
		
		--Add the green duration circle, and kill the plague ward after the duration ends.
		plague_ward_unit:AddNewModifier(plague_ward_unit, nil, "modifier_kill", {duration = keys.Duration})
		plague_ward_unit_2:AddNewModifier(plague_ward_unit, nil, "modifier_kill", {duration = keys.Duration})
		if scepter then
			plague_ward_unit_3:AddNewModifier(plague_ward_unit, nil, "modifier_kill", {duration = keys.Duration})
		end
		
		local ability_index_1 = caster:GetAbilityByIndex(0) 
		if ability_index_1 ~= nil then 
			if ability_index_1:GetAbilityName() == "catmancer_miaulement" then
				local levelability = ability_index_1:GetLevel()
				print("Level Miaulement :" .. levelability)
				ability.levelability = levelability
			end
		end
		
		print(ability.levelability)
		LearnCatAbilities( plague_ward_unit, ability.levelability )
		LearnCatAbilities( plague_ward_unit_2, ability.levelability )
		if scepter then
		LearnCatAbilities( plague_ward_unit_3, ability.levelability )
		end
	end
end

function LearnCatAbilities( unit, level )
	print("lvlupabilities")
	-- Learn its abilities, for lone_druid_bear its return lvl 2, entangle lvl 3, demolish lvl 4. By Index

		local ability = unit:GetAbilityByIndex(0)
		if ability:GetAbilityName() == "catmancer_miaulement" then
			ability:SetLevel(level)
			print("Set Level "..level.." on "..ability:GetAbilityName())
		end

end
