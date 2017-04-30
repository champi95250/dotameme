function Reincarnation( event )
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	local casterHP = caster:GetHealth()
	local targetHP = target:GetHealth()
	local casterMana = caster:GetMana()
	local abilityManaCost = ability:GetManaCost( ability:GetLevel() - 1 )
	

	-- Change it to your game needs
	local respawnTimeFormula = caster:GetLevel() * 4
	
		
		-- Variables for Reincarnation
		local reincarnate_time = ability:GetLevelSpecialValueFor( "reincarnate_time", ability:GetLevel() - 1 )
		local casterGold = target:GetGold()
		local respawnPosition = target:GetAbsOrigin()
		
		local particleName = "particles/mercy/mercy_ultimate_light_4.vpcf"
		local particlec = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl(particlec, 0, respawnPosition)
		
		-- Start cooldown on the passive
		-- ability:StartCooldown(cooldown)
		-- Set the gold back
		
		if not target:IsAlive() then
		-- Set the short respawn time and respawn position
		target:SetRespawnPosition(respawnPosition) 
		target:RespawnHero(false,false,false)
		
		local model = "models/props_gameplay/tombstoneb01.vmdl"
		local grave = Entities:CreateByClassname("prop_dynamic")
    	grave:SetModel(model)
    	grave:SetAbsOrigin(respawnPosition)

    	local particleName = "particles/mercy/mercy_ultimate_light.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, target )
		ParticleManager:SetParticleControl(particle1, 0, respawnPosition)
		
		local particleName = "particles/mercy/mercy_ultimate_light_4.vpcf"
		local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, target )
		ParticleManager:SetParticleControl(particle2, 0, respawnPosition)
		
		

    	-- End grave after reincarnating
    	Timers:CreateTimer(reincarnate_time, function() grave:RemoveSelf() end)		

		-- Sounds
		target:EmitSound("Hero_SkeletonKing.Reincarnate")
		target:EmitSound("Hero_SkeletonKing.Death")
		
		end	


end
