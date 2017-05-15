function Chronosphere( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local caster_point = caster:GetAbsOrigin()
	-- local target_point = keys.target_points[1]

	-- Special Variables
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() - 1))

	-- Dummy
	local dummy_modifier = keys.dummy_aura
	local dummy = CreateUnitByName("npc_dummy_unit", caster_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = duration})

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), caster_point, 1000, duration, false)

	-- Timer to remove the dummy
	Timers:CreateTimer(duration, function() dummy:RemoveSelf() end)
end

function ChronosphereAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local aura_modifier = keys.aura_modifier
	local ignore_rick = ability:GetLevelSpecialValueFor("ignore_rick", ability_level)
	local duration = ability:GetLevelSpecialValueFor("aura_interval", ability_level)

	-- Variable for deciding if Chronosphere should affect Faceless Void
	if ignore_rick == 0 then ignore_rick = false
	else ignore_rick = true end

	-- Check if it is a caster controlled unit or not
	-- Caster controlled units get the phasing and movement speed modifier
	if (caster:GetPlayerOwner() == target:GetPlayerOwner()) or (target:GetName() == "npc_dota_hero_jakiro" and ignore_rick) then
		-- target:AddNewModifier(caster, ability, "modifier_chronosphere_speed_lua", {duration = duration})
	else
	-- Everyone else gets immobilized and stunned
		target:InterruptMotionControllers(false)
		ability:ApplyDataDrivenModifier(caster, target, aura_modifier, {duration = duration}) 
	end
end