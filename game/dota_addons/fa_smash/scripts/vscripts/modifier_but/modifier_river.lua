modifier_river = class({})

--------------------------------------------------------------------------------

function modifier_river:IsHidden()
	return true
end

function modifier_river:IsDebuff()
	return false
end

function modifier_river:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_river:OnCreated()
		self:StartIntervalThink( 1 / 32 )
	end

--------------------------------------------------------------------------------

	function modifier_river:OnIntervalThink()
		local parent = self:GetParent()
		
		if self:IsInRiver() then
			if GameSettings.river_heal > 0 then
				parent:AddNewModifier( parent, nil, "modifier_river_radiation", {} )
			end
			
			if GameSettings.river_irradiated > 0 then
				parent:AddNewModifier( parent, nil, "modifier_river_sticky", {} )
			end
			
			if GameSettings.river_ice > 0 then
				parent:AddNewModifier( parent, nil, "modifier_ice_slide", {} )
			end
		else
			if parent:HasModifier( "modifier_ice_slide" ) then
				parent:RemoveModifierByName( "modifier_ice_slide" )
			end
		end
	end
	
--------------------------------------------------------------------------------

	function modifier_river:IsInRiver()
		local parent = self:GetParent()
		local origin = parent:GetAbsOrigin()
		
		if origin.y > -4000.0 and origin.z < 129.0 then
			return true
		end
		
		return false
	end
end