function suivi( keys )
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
	target:SetForceAttackTarget(caster)
	-- Set the force attack target to be the caster

end

function stop( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function start_suivi( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("candy_missile_duration", (ability:GetLevel() -1))
	local talent = caster:FindAbilityByName("special_bonus_unique_pedo")

	if talent and talent:GetLevel() > 0 then
		print("Talent Active")
		duration = duration + 1
	else
		duration = duration
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_candy_bear", {duration = duration})
end