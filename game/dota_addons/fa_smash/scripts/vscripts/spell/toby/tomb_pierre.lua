function TombPierre(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local tomb_range = ability:GetLevelSpecialValueFor("rang_aoe", (ability:GetLevel() -1))
	local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() -1))

	local talent = caster:FindAbilityByName("special_bonus_unique_toby")
	local talent_2 = caster:FindAbilityByName("special_bonus_unique_toby_2")

	if talent and talent:GetLevel() > 0 then
		print("Talent Active")
		damage_per_second = damage_per_second + 30
	else
		damage_per_second = damage_per_second
	end

	if talent_2 and talent_2:GetLevel() > 0 then
		print("Talent Active")
		tomb_range = tomb_range + 250
	else
		tomb_range = tomb_range
	end
	
	-- Units to take the initial echo slam damage, and to send echo projectiles from
	local initial_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, tomb_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	
	-- search units
	for i,initial_unit in ipairs(initial_units) do
		-- Applies the initial damage to the target
		ApplyDamage({victim = initial_unit, attacker = caster, damage = damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Caster Location
		local caster_loc = caster:GetAbsOrigin()

		-- Knockback Table
		local tomb_bash =	
		{
			should_stun = 0.3,
			knockback_duration = 0.3,
			duration = 0.3,
			knockback_distance = 0,
			knockback_height = 110,
			center_x = caster_loc.x,
			center_y = caster_loc.y,
			center_z = caster_loc.z
		}

		initial_unit:RemoveModifierByName("modifier_knockback")
		initial_unit:AddNewModifier(caster, ability, "modifier_knockback", tomb_bash)

	end
end