modifier_regen = class({})

function modifier_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACKED,
	}
 
	return funcs
end

function modifier_regen:OnCreated( kv )
	if IsClient() then return end
end

function modifier_regen:GetModifierConstantHealthRegen()
	return 30
end

function modifier_regen:GetModifierHealthRegenPercentage()
	return 5
end

function modifier_regen:GetModifierConstantManaRegen()
	return 25
end

function modifier_regen:GetModifierPercentageManaRegen()
	return 2
end

function modifier_regen:OnAttacked(keys)
	if IsServer() then
	    if keys.target == self:GetParent() then
	      if self:GetCaster():HasModifier("modifier_regen") then
	        self:GetCaster():RemoveModifierByName("modifier_regen")
	      end
	    end
	end
end

function modifier_regen:RemoveOnDeath()
	return true
end

function modifier_regen:IsPurgable()
	return true
end

function modifier_regen:IsPurgeException()
	return true
end

function modifier_regen:GetTexture()
	return "custom/rune_heal"
end