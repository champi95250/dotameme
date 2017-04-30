modifier_branches = class({})

--------------------------------------------------------------------------------

function modifier_branches:IsHidden()
	return true
end

function modifier_branches:IsDebuff()
	return false
end

function modifier_branches:IsPurgable()
	return false
end

function modifier_branches:RemoveOnDeath()
	return false
end

function modifier_branches:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_branches:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	 
	return funcs
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_branches:OnCreated( event )
		self:StartIntervalThink( 1 / 32 )
	end

--------------------------------------------------------------------------------

	function modifier_branches:OnIntervalThink()
		local parent = self:GetParent()
		if parent.GetGold then
			self:SetStackCount( math.floor( parent:GetGold() / 200 ) )
			parent:CalculateStatBonus()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_branches:GetModifierBonusStats_Strength( event )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_branches:GetModifierBonusStats_Agility( event )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_branches:GetModifierBonusStats_Intellect( event )
	return self:GetStackCount()
end