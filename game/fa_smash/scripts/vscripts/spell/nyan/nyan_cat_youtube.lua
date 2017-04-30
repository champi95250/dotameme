function damage(event)

	-- Ability
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heroes_around = event.target_entities
	local mainAbilityDamageType = ability:GetAbilityDamageType()
	local level = ability:GetLevel()
	local random_abi = 0
	
	-- Sound 
	local tunak = "Nyan.tunak_tunak.Cast"
	local jihad = "Nyan.jihad.Cast"
	local hey = "Nyan.heyyeaaeyaaa.Cast"
	local banana = "Nyan.banana.Cast"
	
	-- random
	-- 1 = Banana
	-- 2 = Heyeyeaeayea
	-- 3 = Tunak
	-- 4 = Jihad Bomb
	random_abi = RandomInt(1, 4) 
	print(random_abi)
	
	-- 1
	local ban_effect = ability:GetLevelSpecialValueFor( "meme_effect_banana", ability:GetLevel() - 1 )
	local ban_duration = ability:GetLevelSpecialValueFor( "meme_duration_banana", ability:GetLevel() - 1 )
	local ban_range = ability:GetLevelSpecialValueFor( "meme_range_banana", ability:GetLevel() - 1 )
	-- 2
	local hey_heal = ability:GetLevelSpecialValueFor( "meme_effect_heyeyey", ability:GetLevel() - 1 )
	local hey_duration = ability:GetLevelSpecialValueFor( "meme_duration_heyeyey", ability:GetLevel() - 1 )
	-- 3
	local tun_as = ability:GetLevelSpecialValueFor( "meme_effect_tunak_as", ability:GetLevel() - 1 )
	local tun_ms = ability:GetLevelSpecialValueFor( "meme_effect_tunak_ms", ability:GetLevel() - 1 )
	local tun_duration = ability:GetLevelSpecialValueFor( "meme_duration_tunak", ability:GetLevel() - 1 )
	-- 4
	local jih_delay = ability:GetLevelSpecialValueFor( "meme_jihad_bomdelay", ability:GetLevel() - 1 )
	local jih_range = ability:GetLevelSpecialValueFor( "meme_jihad_bomb_range", ability:GetLevel() - 1 )
	local jih_damage = ability:GetLevelSpecialValueFor( "meme_jihad_bomb_damage", ability:GetLevel() - 1 )

	-- ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = mainAbilityDamageType })
	if random_abi == 1 then 
		print("Banana")
		EmitSoundOn(banana, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nyan_cat_banana_caster", {duration = ban_duration})
		for _,unit in pairs(heroes_around) do
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_nyan_cat_banana_unit", {duration = ban_duration})
		end
	elseif random_abi == 2 then 
		print("Hey")
		EmitSoundOn(hey, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nyan_cat_hey_aura", {duration = hey_duration})
	elseif random_abi == 3 then 
		print("Tunak")
		EmitSoundOn(tunak, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nyan_cat_tunak", {duration = tun_duration})
	elseif random_abi == 4 then 
		print("Jihad")
		EmitSoundOn(jihad, caster)
		Timers:CreateTimer( jih_delay, function()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_nyan_cat_jihad", {duration = 2.5})
		end)
	end

end


function Suicide( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local respawn_time_percentage = ability:GetLevelSpecialValueFor("meme_jihad_respawn_time", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("meme_jihad_bomb_range", ability_level) 
	local vision_duration = 1.5

	-- Insert modifiers into the table that would otherwise prevent a units death
	local exception_table = {}
	table.insert(exception_table, "modifier_dazzle_shallow_grave")
	table.insert(exception_table, "modifier_shallow_grave_datadriven")

	-- Remove the modifiers if they exist
	local modifier_count = caster:GetModifierCount()
	for i = 0, modifier_count do
		local modifier_name = caster:GetModifierNameByIndex(i)
		local modifier_check = false

		-- Compare if the modifier is in the exception table
		-- If it is then set the helper variable to true and remove it
		for j = 0, #exception_table do
			if exception_table[j] == modifier_name then
				modifier_check = true
				break
			end
		end

		-- Remove the modifier depending on the helper variable
		if modifier_check then
			caster:RemoveModifierByName(modifier_name)
		end
	end

	-- Create the vision and kill the caster
	ability:CreateVisibilityNode(caster_location, vision_radius, vision_duration)
	caster:Kill(ability, caster)

	-- Modify the respawn time
	caster:SetTimeUntilRespawn(caster:GetRespawnTime() * respawn_time_percentage)
end

function Bananacall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function BananacallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end