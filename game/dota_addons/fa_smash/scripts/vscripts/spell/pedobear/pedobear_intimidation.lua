function intimidation(keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	if target:IsHero() then
		local previous_stack_count = 0
		if target:HasModifier("modifier_intimidation_debuff") then
			target:SetModifierStackCount("modifier_intimidation_debuff", caster, previous_stack_count + 1)
		end
		ability:ApplyDataDrivenModifier(caster, target, "modifier_intimidation_debuff", nil)
		target:SetModifierStackCount("modifier_intimidation_debuff", caster, previous_stack_count + 1)	
	end
end

function destroy(keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	if target:HasModifier("modifier_intimidation_debuff") then
		local previous_stack_count = target:GetModifierStackCount("modifier_intimidation_debuff", caster)
		if previous_stack_count > 1 then
			target:SetModifierStackCount("modifier_intimidation_debuff", caster, previous_stack_count - 1)
		else
			target:RemoveModifierByNameAndCaster("modifier_intimidation_debuff", caster)
		end
	end
end