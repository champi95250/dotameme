modifier_rune_mushroom = class({})

function modifier_rune_mushroom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
 
	return funcs
end

function modifier_rune_mushroom:OnCreated( kv )
	if IsClient() then return end
end

function modifier_rune_mushroom:OnRefresh( kv )
	if IsClient() then return end
end

function modifier_rune_mushroom:GetModifierMoveSpeedBonus_Constant()
	return 40
end

function modifier_rune_mushroom:GetModifierAttackSpeedBonus_Constant()
	return -50
end

function modifier_rune_mushroom:GetModifierBaseAttack_BonusDamage()
	return 85
end

function modifier_rune_mushroom:GetModifierPhysicalArmorBonus()
	return 10
end

function modifier_rune_mushroom:GetModifierModelScale()
	return 50
end

function modifier_rune_mushroom:RemoveOnDeath()
	return true
end

function modifier_rune_mushroom:IsPurgable()
	return true
end

function modifier_rune_mushroom:IsPurgeException()
	return true
end

function modifier_rune_mushroom:StatusEffectPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_rune_mushroom:AllowIllusionDuplicate()
	return true
end

function modifier_rune_mushroom:GetTexture()
	return "custom/rune_grow"
end