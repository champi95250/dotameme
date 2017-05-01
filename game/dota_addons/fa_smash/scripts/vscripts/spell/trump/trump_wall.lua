function trump_wall(keys)
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")
	local ability = keys.ability

	local caster_point = keys.target_points[1]
	local direction_to_target_point = keys.caster:GetForwardVector()
	target_point = caster_point + (direction_to_target_point)
	local direction_to_target_point_normal = Vector(-direction_to_target_point.y, direction_to_target_point.x, direction_to_target_point.z)
	local vector_distance_from_center = (direction_to_target_point_normal * (keys.NumWallElements * keys.WallElementSpacing)) / 2
	local one_end_point = target_point - vector_distance_from_center
	local one_frist_point = target_point + vector_distance_from_center
	
	--Display the Ice Wall particles in a line.
	local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/trump/wall_base.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, target_point + vector_distance_from_center)
	
	--local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, keys.caster)
	--ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 0, target_point - vector_distance_from_center)
	--ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 1, target_point + vector_distance_from_center)
	
	--Ice Wall's duration is dependent on the level of Quas.
	local ability = keys.ability
	local ice_wall_duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)	
	
	--Remove the Ice Wall particles after the duration ends.
	Timers:CreateTimer({
		endTime = ice_wall_duration,
		callback = function()
			ParticleManager:DestroyParticle(ice_wall_particle_effect, false)
			--ParticleManager:DestroyParticle(ice_wall_particle_effect_b, false)
		end
	})
	
	--DebugDrawLine(one_end_point, one_frist_point, 255, 255, 0, true, 10)
		local obstructions = {}

		for i = 0, keys.NumWallElements - 1 do
		local angle = math.rad(360 / keys.NumWallElements * i)
		local pso = SpawnEntityFromTableSynchronous("point_simple_obstruction", {
		origin = one_end_point + direction_to_target_point_normal * (keys.WallElementSpacing * i * 1.06)
		 ,
		})

		table.insert(obstructions, pso)
		
		Timers:CreateTimer({
			endTime = ice_wall_duration,
			callback = function()
			 for _, pso in ipairs(obstructions) do
			pso:RemoveSelf()

			end

				
			end
		})
		end

	end