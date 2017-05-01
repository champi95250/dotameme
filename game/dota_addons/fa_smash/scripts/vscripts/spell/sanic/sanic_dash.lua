LinkLuaModifier( "modifier_sanic_damage", "spell/sanic/modifier_sanic_damage.lua" ,LUA_MODIFIER_MOTION_NONE )

function damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	caster:RemoveModifierByName("modifier_sanic_damage") 
	caster:AddNewModifier(caster, ability, "modifier_sanic_damage", {duration = 8.0})
	
	if caster:HasModifier("modifier_mlg_sound") then
		caster:EmitSound("Mlg.gotta")
	end
end