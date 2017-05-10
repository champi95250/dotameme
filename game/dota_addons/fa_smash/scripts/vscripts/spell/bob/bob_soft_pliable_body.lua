function bob_soft_pliable( event )
	-- Variables
	local damage = event.DamageTaken
	print(damage)
	local unit = event.unit
	local ability = event.ability
	local percentage = ability:GetLevelSpecialValueFor("damage_reduction", event.ability:GetLevel() - 1 ) / 100
	unit.OldHealth = unit:GetHealth() + damage
	
	-- Track how much damage was already absorbed by the shield

	
	local newHealth = unit.OldHealth - ( damage - (damage * percentage) )
	print("unit.OldHealth "..unit.OldHealth)
	print("Damage Taken: "..damage)
	print("Damage REDUCTION: "..damage * percentage)
	print("VIE: "..newHealth)
	if unit.OldHealth >= 400 then
		unit:SetHealth(newHealth)
		print("REDUC OK")
	end
end