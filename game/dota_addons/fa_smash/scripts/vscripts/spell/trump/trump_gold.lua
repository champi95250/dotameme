function trump_gold(keys)

	local caster = keys.caster
	local ability = keys.ability
	local casterGold = caster:GetGold()
	local prc = ability:GetLevelSpecialValueFor("pourcentage", ability:GetLevel() - 1)	
	local cd_agha = ability:GetLevelSpecialValueFor("cd_aghanim_scepter", ability:GetLevel() - 1)	
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	local obtien = casterGold * prc / 100-- 100 * 0.2 = 20
	local scepter = HasScepter(caster)
	
	if ability:IsCooldownReady() then
		if scepter then
			ability:StartCooldown(cd_agha * GetCooldownReduction(caster))
		else
			ability:StartCooldown(cooldown * GetCooldownReduction(caster))
		end
		caster:ModifyGold(obtien, true, 0)
		
	end
end
