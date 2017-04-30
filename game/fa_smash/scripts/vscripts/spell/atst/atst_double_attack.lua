function double( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster	
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local cooldown_time = cooldown * GetCooldownReduction(caster)
	
	local modifierName = "modifier_at_st_double_attack"
	
	ability:StartCooldown(cooldown_time)

	caster:RemoveModifierByName(modifierName) 
	
	Timers:CreateTimer(0.2, function()
		caster:PerformAttack(target,true,true,true,true,true,false,true)
		end)

	Timers:CreateTimer(cooldown_time, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end)	
end