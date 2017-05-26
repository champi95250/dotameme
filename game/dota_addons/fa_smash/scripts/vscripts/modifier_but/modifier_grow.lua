modifier_grow = class({})

function modifier_grow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
 
	return funcs
end

function modifier_grow:OnCreated( kv )
	if IsClient() then return end
	local oldStacks = self:GetStackCount() or 0
	if kv and kv.stacks then
		self:SetStackCount(kv.stacks)
	else
		self:SetStackCount(1)
	end
	if self:GetStackCount() ~= oldStacks then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(p)
		StartSoundEventFromPosition("Tiny.Grow", self:GetParent():GetAbsOrigin())
	end
end

function modifier_grow:OnRefresh( kv )
	if IsClient() then return end
	local oldStacks = self:GetStackCount() or 0
	if kv and kv.stacks then
		self:SetStackCount(kv.stacks)
	else
		self:IncrementStackCount()
	end
	if self:GetStackCount() ~= oldStacks then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(p)
		StartSoundEventFromPosition("Tiny.Grow", self:GetParent():GetAbsOrigin())
	end
end

function modifier_grow:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * 12 + 30
end

function modifier_grow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * -16 - 5
end

function modifier_grow:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() * 55 + 5
end

function modifier_grow:GetModifierModelScale()
	return self:GetStackCount() * 27
end

function modifier_grow:RemoveOnDeath()
	return false
end

function modifier_grow:IsPurgable()
	return false
end

function modifier_grow:IsPurgeException()
	return false
end

function modifier_grow:StatusEffectPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_grow:AllowIllusionDuplicate()
	return true
end

function modifier_grow:GetTexture()
	return "tiny_grow"
end