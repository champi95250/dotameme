function Multicast(keys)
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local ability_cast
local two_times = ability:GetLevelSpecialValueFor( "multicast_2_times", ability:GetLevel() - 1 )
local three_times = ability:GetLevelSpecialValueFor( "multicast_3_times", ability:GetLevel() - 1 )
local four_times = ability:GetLevelSpecialValueFor( "multicast_4_times", ability:GetLevel() - 1 )
local rand = math.random(1,130)
local multicast = 1
local cast_time = 0.25

	-- Determines the mulicast multiplier
	if rand < two_times then
		multicast = 2
	elseif rand < two_times + three_times then -- 50+25 = 75
		multicast = 3
	elseif rand < two_times + three_times + four_times then	-- 75+15 = 90
		multicast = 4
	end
	print("-----------------------------------------")
	print("Multicast: "..multicast)
	-- Small delay
	Timers:CreateTimer(0.01, function()

	-- Ensures the caster and ability still exist after the delay
	if IsValidEntity(caster) and IsValidEntity(ability) then
		for i = 0, 23 do
			if caster:GetAbilityByIndex(i) ~= nil then
				local cd = caster:GetAbilityByIndex(i):GetCooldownTimeRemaining()
				local full_cd = caster:GetAbilityByIndex(i):GetCooldown(caster:GetAbilityByIndex(i):GetLevel()-1)
				full_cd = full_cd * GetCooldownReduction(caster)  
				-- There is a delay after the ability cast event and before the ability goes on cooldown
				-- If the ability is on cooldown and the cooldown is within a small buffer of the full cooldown
				-- We set ability_cast
				if cd > 0 and full_cd - cd < 1.00 then
					ability_cast = caster:GetAbilityByIndex(i)
				end
			end
		end

		local fireblast_mana_cost = ability:GetLevelSpecialValueFor( "fireblast_mana_cost", ability:GetLevel() - 1 )
		local fireblast_cooldown = ability:GetLevelSpecialValueFor( "fireblast_cooldown", ability:GetLevel() - 1 )
		local bloodlust_cooldown = ability:GetLevelSpecialValueFor( "bloodlust_cooldown", ability:GetLevel() - 1 )
		local ignite_range = ability:GetLevelSpecialValueFor( "ignite_range", ability:GetLevel() - 1 )
		-- local distance = math.sqrt((caster:GetAbsOrigin().x - target:GetAbsOrigin().x)^2 + (caster:GetAbsOrigin().y - target:GetAbsOrigin().y)^2)

		if ability_cast ~= nil then
		print("Ability Valid")
			if multicast ~= 1 then
				local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) 
				ParticleManager:SetParticleControl(particle, 0, Vector(0, 0, 100))
				ParticleManager:SetParticleControl(particle, 1, Vector(multicast, 0, 0))

				if ability_cast:IsPassive() or ability_cast:IsToggle() then
					print("Passive or Toggle, ignoring")
					return
				end

				if ability_cast:GetLevel() > 0 then
					if ability_cast then						
						if multicast == 2 then
							Timers:CreateTimer(cast_time, function()
								CheckBehavior(caster, target, ability_cast)
							end)
							EmitSoundOn("Hero_OgreMagi.Fireblast.x1", target)
						end

						if multicast > 2 then
							if multicast == 3 then
								Timers:CreateTimer(cast_time, function()
									CheckBehavior(caster, target, ability_cast)
									Timers:CreateTimer(cast_time, function()
										CheckBehavior(caster, target, ability_cast)
									end)
								end)
								
								EmitSoundOn("Hero_OgreMagi.Fireblast.x2", target)
							end
						end

						if multicast > 3 then
							Timers:CreateTimer(cast_time, function()
								CheckBehavior(caster, target, ability_cast)
								Timers:CreateTimer(cast_time, function()
									CheckBehavior(caster, target, ability_cast)
									Timers:CreateTimer(cast_time, function()
										CheckBehavior(caster, target, ability_cast)
									end)
								end)
							end)
							EmitSoundOn("Hero_OgreMagi.Fireblast.x3", target)
						end
					end
					
				end
			end
		end	
	end
	end)
end

function CheckBehavior(caster, target, ability_cast)
	if bit.band(ability_cast:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NO_TARGET) > 0 then
		ability_cast:OnSpellStart()
	elseif bit.band(ability_cast:GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) > 0 then
		caster:CastAbilityOnTarget(target, cast_ability, caster:GetPlayerOwnerID())
		caster:SetCursorCastTarget(target)
		caster:SetCursorPosition(target:GetAbsOrigin())
		ability_cast:OnSpellStart()
		print("Cast: Unit Target")
	end
end
