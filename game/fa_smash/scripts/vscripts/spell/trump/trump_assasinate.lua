function trump_attack( keys )

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local speed = ability:GetLevelSpecialValueFor( "projectile_speed" , ability:GetLevel() - 1 )

	if target:HasModifier( "modifier_track_datadriven" ) then
		keys.caster.assassinate_target = keys.target
		local info = {
		Target = keys.caster.assassinate_target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = speed,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}
		ProjectileManager:CreateTrackingProjectile( info )
	end
	
end
