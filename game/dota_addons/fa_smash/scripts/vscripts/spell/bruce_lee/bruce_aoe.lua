function stack_damage(event)

	-- Ability
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heroes_around = event.target_entities
	local mainAbilityDamageType = ability:GetAbilityDamageType()
	local level = ability:GetLevel()
	local damage = ability:GetLevelSpecialValueFor( "base_damage", ability:GetLevel() - 1 )

	local talent = caster:FindAbilityByName("special_bonus_unique_brucelee_1") -- base + creep
	local talent_2 = caster:FindAbilityByName("special_bonus_unique_brucelee_2") -- hero
	-- 1
	local damage_hero = ability:GetLevelSpecialValueFor( "damage_hero_extra", ability:GetLevel() - 1 )
	local damage_creep = ability:GetLevelSpecialValueFor( "damage_unit_extra", ability:GetLevel() - 1 )

	if talent and talent:GetLevel() > 0 then
		print("Talent Active")
		damage = damage + 40
		damage_creep = damage_creep + 40
	else
		damage = damage
		damage_creep = damage_creep
	end

	if talent_2 and talent:GetLevel() > 0 then
		print("Talent Active")
		damage_hero = damage_hero + 75
	else
		damage_hero = damage_hero
	end
	
	for _,unit in pairs(heroes_around) do
		if unit:IsRealHero() then
			damage = damage + damage_hero
			caster:EmitSound("Brucelee.Kick.Cast")
		else
			damage = damage + damage_creep
			caster:EmitSound("Brucelee.Kick.Cast")
		end
		print(damage)
		
		
		local damage_table = {}
		
		Timers:CreateTimer( 0.1, function()
		damage_table.attacker = caster
		damage_table.damage_type = mainAbilityDamageType
		damage_table.ability = ability
		damage_table.victim = unit

		damage_table.damage = damage

		ApplyDamage(damage_table)
		end)
	end
	
end