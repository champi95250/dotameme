function Jinada( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local cooldown_time = cooldown * GetCooldownReduction(caster)
	
	local modifierName = "modifier_at_st_critical"

	ability:StartCooldown(cooldown_time)

	caster:RemoveModifierByName(modifierName) 

	Timers:CreateTimer(cooldown_time, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end)	
end