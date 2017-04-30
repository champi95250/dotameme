function PoisonNova( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)
	ability.damage = 0
	
	if scepter then
		ability.damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	else
		ability.damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	end
	
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = ability.damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL

	ApplyDamage(damage_table)
end

function PoisonEffect( keys )	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local duration_agha = ability:GetLevelSpecialValueFor("duration_scepter", ability_level)
	local scepter = HasScepter(caster)
	
	if scepter then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_poison_nova_debuff_datadriven", {duration = duration_agha})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_poison_nova_debuff_datadriven", {duration = duration})
	end
	
end

function check_agha( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)
	local cd_agha = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)
	
	if scepter then
		ability:StartCooldown(cd_agha * GetCooldownReduction(caster))
	end
end