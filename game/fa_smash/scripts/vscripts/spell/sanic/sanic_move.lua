LinkLuaModifier( "modifier_sanic_movespeed", "spell/sanic/modifier_sanic_movespeed.lua" ,LUA_MODIFIER_MOTION_NONE )

function LevelUpAbility(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	caster:RemoveModifierByName("modifier_sanic_movespeed") 
	caster:AddNewModifier(caster, ability, "modifier_sanic_movespeed", {})
end