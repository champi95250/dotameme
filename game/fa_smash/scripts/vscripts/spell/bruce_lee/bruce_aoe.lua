function stack_damage(event)

	-- Ability
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heroes_around = event.target_entities
	local mainAbilityDamageType = ability:GetAbilityDamageType()
	local level = ability:GetLevel()
	local damage = ability:GetLevelSpecialValueFor( "base_damage", ability:GetLevel() - 1 )
	-- 1
	local damage_hero = ability:GetLevelSpecialValueFor( "damage_hero_extra", ability:GetLevel() - 1 )
	local damage_creep = ability:GetLevelSpecialValueFor( "damage_unit_extra", ability:GetLevel() - 1 )
	
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