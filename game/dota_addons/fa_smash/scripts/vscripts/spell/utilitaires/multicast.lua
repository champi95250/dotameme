function Multicast(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_cast
	local two_times = ability:GetLevelSpecialValueFor( "multicast_2_times", ability:GetLevel() - 1 )
	local three_times = ability:GetLevelSpecialValueFor( "multicast_3_times", ability:GetLevel() - 1 )
	local four_times = ability:GetLevelSpecialValueFor( "multicast_4_times", ability:GetLevel() - 1 )
	local rand = math.random(1,130)
	print(rand)
	local multicast = 1
	
	-- Determines the mulicast multiplier
	if rand < two_times then
		multicast = 2
	elseif rand < two_times + three_times then -- 50+25 = 75
		multicast = 3
	elseif rand < two_times + three_times + four_times then	-- 75+15 = 90
		multicast = 4
	end
	print(multicast)
	-- Small delay
	Timers:CreateTimer(0.01,
    	function()
	
	-- Ensures the caster and ability still exist after the delay
	if IsValidEntity(caster) and IsValidEntity(ability) then
		-- Finds the ability that caused the event trigger by checking if the cooldown is equal to the full cooldown
		for i=0, 15 do
			if caster:GetAbilityByIndex(i) ~= null then
				
				local cd = caster:GetAbilityByIndex(i):GetCooldownTimeRemaining()
				local full_cd = caster:GetAbilityByIndex(i):GetCooldown(caster:GetAbilityByIndex(i):GetLevel()-1)
				full_cd = full_cd * GetCooldownReduction(caster)  
				-- There is a delay after the ability cast event and before the ability goes on cooldown
				-- If the ability is on cooldown and the cooldown is within a small buffer of the full cooldown
				-- We set ability_cast
				if cd > 0 and full_cd - cd < 1.00 then
					ability_cast = caster:GetAbilityByIndex(i)
					print(ability_cast)
				end
			end
		end
	
		local fireblast_mana_cost = ability:GetLevelSpecialValueFor( "fireblast_mana_cost", ability:GetLevel() - 1 )
		local fireblast_cooldown = ability:GetLevelSpecialValueFor( "fireblast_cooldown", ability:GetLevel() - 1 )
		local bloodlust_cooldown = ability:GetLevelSpecialValueFor( "bloodlust_cooldown", ability:GetLevel() - 1 )
		local ignite_range = ability:GetLevelSpecialValueFor( "ignite_range", ability:GetLevel() - 1 )
		-- local distance = math.sqrt((caster:GetAbsOrigin().x - target:GetAbsOrigin().x)^2 + (caster:GetAbsOrigin().y - target:GetAbsOrigin().y)^2)
		
		if ability_cast ~= nil then
		print("apls")
			if multicast ~= 1 then
			print("Multicast")
				-- Not sure how to get the particle to show the proper multiplier
				-- local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_OVERHEAD_FOLLOW, caster) 
				-- ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", caster:GetAbsOrigin(), true)
				-- Fireblast
				if not ability_cast:IsPassive() and not ability_cast:IsToggle() and ability_cast:GetLevel() > 0 then
					if ability_cast then
						if bit.band( ability_cast:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) > 0 then
							caster:SetCursorCastTarget( caster )
							caster:SetCursorPosition( caster:GetAbsOrigin() )
							print("aa")
						else
							caster:SetCursorCastTarget( caster )
							caster:SetCursorPosition( caster:GetAbsOrigin() )
							print("bb")
						end
						print("allo")
						if multicast == 2 then
							Timers:CreateTimer(0.15,
								function()
								ability_cast:OnSpellStart()
							end)
							EmitSoundOn(keys.sound1, target)
						end
						-- Third instance of stun and damage
						if multicast > 2 then
							
							if multicast == 3 then
								Timers:CreateTimer(0.15,
									function()
									ability_cast:OnSpellStart()
								end)
								Timers:CreateTimer(0.30,
									function()
									ability_cast:OnSpellStart()
								end)
								EmitSoundOn(keys.sound2, target)
							end
						end
						-- Fourth instance of stun and damage
						if multicast > 3 then
							Timers:CreateTimer(0.15,
								function()
								ability_cast:OnSpellStart()
							end)
							Timers:CreateTimer(0.30,
								function()
								ability_cast:OnSpellStart()
							end)
							Timers:CreateTimer(0.45,
								function()
								ability_cast:OnSpellStart()
							end)
							EmitSoundOn(keys.sound3, target)
						end
						
					end
					
				end
			end
		end	
	end
	end)
end