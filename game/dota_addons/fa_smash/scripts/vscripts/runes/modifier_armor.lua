modifier_armor = class({})

function modifier_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
 
	return funcs
end

function modifier_armor:OnCreated( kv )
	if IsClient() then return end
end

function modifier_armor:GetModifierPhysicalArmorBonus()
	return 50
end

function modifier_armor:GetModifierMagicalResistanceBonus()
	return 25
end

function modifier_armor:RemoveOnDeath()
	return true
end

function modifier_armor:IsPurgable()
	return true
end

function modifier_armor:IsPurgeException()
	return true
end

function modifier_armor:AllowIllusionDuplicate()
	return false
end

function modifier_armor:GetTexture()
	return "custom/rune_armor"
end