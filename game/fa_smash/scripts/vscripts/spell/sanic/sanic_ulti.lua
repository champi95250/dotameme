LinkLuaModifier( "modifier_sanic_movespeed_ulti", "spell/sanic/modifier_sanic_movespeed_ulti.lua" ,LUA_MODIFIER_MOTION_NONE )

function speed_up(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	target:RemoveModifierByName("modifier_sanic_movespeed_ulti") 
	target:AddNewModifier(caster, nil, "modifier_sanic_movespeed_ulti", {duration = 14.0})
end