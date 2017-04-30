function critiquedamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_critique_buff"
	local modifierName_scete = "modifier_critique_buff_aghanim"
	local cd_agha = ability:GetLevelSpecialValueFor("cd_scepter", ability:GetLevel() - 1)
	local scepter = HasScepter(caster)
	
	if scepter then
		ability:ApplyDataDrivenModifier(caster, caster, modifierName_scete, {duration=0.2})
		ability:StartCooldown(cd_agha * GetCooldownReduction(caster))
		print("cd : "..cd_agha * GetCooldownReduction(caster))
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {duration=0.2})
	end
	
	if caster:HasModifier("modifier_mlg_sound") then
		caster:EmitSound("Mlg.falconpunch")
	end
	
	
	
	
	Timers:CreateTimer(0.1,function() 
					caster:PerformAttack(target,true,true,true,true,false,false,true)
					if scepter then
						caster:RemoveModifierByName(modifierName_scete)
					else
						caster:RemoveModifierByName(modifierName)
					end
				end)
end