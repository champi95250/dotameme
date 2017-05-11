modifier_river = class({})

function modifier_river:IsHidden()
	return true
end

function modifier_river:IsDebuff()
	return false
end

function modifier_river:IsPurgable()
	return false
end

if IsServer() then
	function modifier_river:OnCreated()
		self:StartIntervalThink( 1 / 32 )
	end

	function modifier_river:OnIntervalThink()
		local parent = self:GetParent()

		if self:IsInRiver() then
			if GameSettings.river_irradiated > 0 then
				parent:AddNewModifier( parent, nil, "modifier_river_radiation", {} )
			end

			if GameSettings.river_heal > 0 then
				parent:AddNewModifier( parent, nil, "modifier_river_sticky", {} )
			end

			if GameSettings.river_ice > 0 then
				parent:AddNewModifier( parent, nil, "modifier_ice_slide", {} )
			end
		else
			if parent:HasModifier( "modifier_ice_slide" ) then
				parent:RemoveModifierByName( "modifier_ice_slide" )
			end
			if parent:HasModifier( "modifier_river_radiation" ) then
				parent:RemoveModifierByName( "modifier_river_radiation" )
			end
		end
	end

	function modifier_river:IsInRiver()
		local parent = self:GetParent()
		local origin = parent:GetAbsOrigin()

		if origin.y > -4000.0 and origin.z < 129.0 then
			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------

modifier_river_radiation = class({})

function modifier_river_radiation:IsHidden()
	return false
end

function modifier_river_radiation:IsDebuff()
	return true
end

function modifier_river_radiation:IsPurgable()
	return false
end

if IsServer() then
	function modifier_river_radiation:OnCreated()
		self:StartIntervalThink(0.5)
		self:OnIntervalThink()
	end

	function modifier_river_radiation:OnIntervalThink()
		local amount = self:GetParent():GetMaxHealth() / 50 -- 2%

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetParent(),
			damage = amount,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
	end
end
