LinkLuaModifier( "modifier_nyan_cat_move", "spell/nyan/modifier_nyan_cat_move.lua" ,LUA_MODIFIER_MOTION_NONE )

function addbuff(keys)
	local caster = keys.caster
	local ability = keys.ability
	local movement = ability:GetLevelSpecialValueFor( "movement_speed", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration_move_speed", ability:GetLevel() - 1 )
	
	caster:AddNewModifier(caster, ability, "modifier_nyan_cat_move", {duration = duration})
end