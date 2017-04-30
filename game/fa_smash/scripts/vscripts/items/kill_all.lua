function YoloSwag()
local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false )
local units2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false )
local units3 = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false )

	for _,v in pairs(units) do
		if v:IsCreature() and v:HasMovementCapability() then
			v:AddNewModifier(nil, nil, "modifier_kill", {})
		end
	end
	for _,v in pairs(units2) do
		if v:HasMovementCapability() then
			v:AddNewModifier(nil, nil, "modifier_kill", {})
		end
	end
	for _,v in pairs(units2) do
		if v:HasMovementCapability() then
			v:AddNewModifier(nil, nil, "modifier_kill", {})
		end
	end
end