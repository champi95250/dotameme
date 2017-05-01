--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function torrent_bubble_allies( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf"
	local target = keys.target_points[1]
	ability.pointage = target
	
	
	local dummy = CreateUnitByName( "npc_dummy_unit", target, false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )

	local bubbles_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", PATTACH_ABSORIGIN, dummy)
	ParticleManager:SetParticleControl(bubbles_pfx, 0, target)
	ParticleManager:SetParticleControl(bubbles_pfx, 1, Vector(320,0,0))
			
	EmitSoundOn( "Ability.pre.Torrent", dummy )
	dummy:ForceKill( true )
			
	-- Destroy particle after delay
	Timers:CreateTimer( delay, function()
			ParticleManager:DestroyParticle( bubbles_pfx, false )
			return nil
		end
	)
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Emit sound at location
]]
function torrent_emit_sound( keys )
	local caster = keys.caster
	local ability = keys.ability
	local dummy = CreateUnitByName( "npc_dummy_unit", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "Ability.Torrent", dummy )
	local torrent_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl(torrent_fx, 0, ability.pointage)
	ParticleManager:SetParticleControl(torrent_fx, 1, Vector(320,0,0))
	ParticleManager:ReleaseParticleIndex(torrent_fx)
	dummy:ForceKill( true )
end

--[[
	Author: kritth, Pizzalol
	Date: February 24, 2016
	Provides obstructed vision of the area
]]
function torrent_vision( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	AddFOWViewer(caster:GetTeamNumber(),target,radius,duration,true)
end