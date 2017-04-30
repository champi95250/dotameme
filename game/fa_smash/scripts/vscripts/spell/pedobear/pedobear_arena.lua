function infest_move_unit( keys ) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1) 
	local maximum_distance = ability:GetLevelSpecialValueFor("maximum_distance", ability:GetLevel() - 1) 
	
	local distance = (target:GetAbsOrigin() - ability.point):Length2D()		
		
		-- If the parent is trying to leave the arena, teleport it back to the edge of it, unless it blinked far away (TP)
		if distance-1 > radius and distance < maximum_distance and not target:HasModifier("modifier_infest_hide") then
			-- Decide the location of the edge
			local direction = (target:GetAbsOrigin() - ability.point):Normalized()
			local edge_point = ability.point + direction * radius

			-- Set the enemy at the edge of the arena
			target:SetAbsOrigin(edge_point)
		end	
end

function sound_scream( keys ) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1) 
	local maximum_distance = ability:GetLevelSpecialValueFor("maximum_distance", ability:GetLevel() - 1) 
	
	local distance = (target:GetAbsOrigin() - ability.point):Length2D()		
		
		-- If the parent is trying to leave the arena, teleport it back to the edge of it, unless it blinked far away (TP)
		if distance-1 < radius and not target:HasModifier("modifier_infest_hide") then
			ability.event1 = keys.target
			EmitSoundOn("Pedobear.rape", ability.event1)
		end	
end

function endsound( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:StopSound("Pedobear.happy")

	print("ok?")
		ability.event1:StopSound("Pedobear.rape")
end

function rendereffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	local particle_formation = "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation.vpcf"
	local particle_field = "particles/pedobear/arena.vpcf"
	
	if caster:HasModifier("modifier_mlg_sound") then
		EmitSoundOn("Pedobear.happy", caster)
	end
	print("loeeel")
	local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_pedo_dummy", {duration = duration+0.6})
	
	ability.point = dummy:GetAbsOrigin()
	AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(),radius, duration, false)
	
	-- Plays the formation sound
	EmitSoundOn("Hero_Disruptor.KineticField", caster)
	
	
	particle_formation = ParticleManager:CreateParticle(particle_formation, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_formation, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_formation, 1, Vector(radius, 1,0))
	ParticleManager:SetParticleControl(particle_formation, 2, Vector(0.1, 0, 0))
	ParticleManager:SetParticleControl(particle_formation, 4, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(particle_formation, 15, dummy:GetAbsOrigin())

	
	particle_field = ParticleManager:CreateParticle(particle_field, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_field, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_field, 1, Vector(radius, 1, 1))
	ParticleManager:SetParticleControl(particle_field, 2, Vector(duration, 0, 0))
	
	Timers:CreateTimer(duration+0.6, function() 
				dummy:Destroy()
	end) 
end
