function bob_soft_pliable( event )
	-- Variables
	local damage = event.DamageTaken
	print(damage)
	local unit = event.unit
	local ability = event.ability
	local percentage = ability:GetLevelSpecialValueFor("damage_reduction", event.ability:GetLevel() - 1 ) / 100
	unit.OldHealth = unit:GetHealth() + damage

	unit.OldHealth = math.floor(math.abs(unit.OldHealth))
	damage = math.floor(math.abs(damage))
	
	-- Track how much damage was already absorbed by the shield

	
	local newHealth = unit.OldHealth - ( damage - (damage * percentage) )
	print("unit.OldHealth "..unit.OldHealth)
	print("Damage Taken: "..damage)
	print("Damage REDUCTION: "..damage * percentage)
	print("VIE newHealth: "..newHealth)
	if not unit.OldHealth == damage then
		unit:SetHealth(newHealth)
		print("REDUC OK")
	end
end