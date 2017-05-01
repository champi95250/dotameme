function Howl( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local ability_level = ability:GetLevel() - 1

	if target:GetUnitName() == "catmancer_1_datadriven" or target:GetUnitName() == "catmancer_2_datadriven" or target:GetUnitName() == "catmancer_3_datadriven" then
		local Miaulment = target:FindAbilityByName("catmancer_miaulement")
		if target:HasAbility("catmancer_miaulement") then
			target:CastAbilityNoTarget(Miaulment, -1)
		end
	end
end