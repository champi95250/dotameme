spike_explosion = class({})

--------------------------------------------------------------------------------

function spike_explosion:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function spike_explosion:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	self.knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
	self.knockback_height = self:GetSpecialValueFor( "knockback_height" )
	self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
	local radius = self:GetSpecialValueFor( "radius" )
	local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)

	local explosion_knockback =	{
		should_stun = self.knockback_duration,
		knockback_duration = self.knockback_distance / 300,
		duration = self.knockback_distance / 300,
		knockback_distance = self.knockback_distance,
		knockback_height = self.knockback_height,
		center_x = caster_pos.x,
		center_y = caster_pos.y,
		center_z = caster_pos.z
	}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", headshot_knockback)
	EmitSoundOn("Hero_KeeperOfTheLight.BlindingLight", caster)
end
