modifier_souls_int = class({})

--------------------------------------------------------------------------------

function modifier_souls_int:IsHidden()
	return false
end

function modifier_souls_int:IsDebuff()
	return false
end

function modifier_souls_int:IsPurgable()
	return false
end

function modifier_souls_int:RemoveOnDeath()
	return false
end

function modifier_souls_int:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_souls_int:GetTexture()
	return "power_mount_int"
end

--------------------------------------------------------------------------------

function modifier_souls_int:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_souls_int:GetModifierBonusStats_Intellect( event )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_souls_int:OnTooltip( event )
	if self:GetParent():IsHero() then
		return 50
	end
	
	return 100
end

--------------------------------------------------------------------------------
	
if IsServer() then
	function modifier_souls_int:OnDeath( event )
		local parent = self:GetParent()
		
		if event.unit == parent and not parent:IsIllusion() then
			local lostSouls = nil
			
			if parent:IsHero() then
				lostSouls = math.floor( self:GetStackCount() / 2 )
			else
				lostSouls = self:GetStackCount()
			end
			
			self:SetStackCount( self:GetStackCount() - lostSouls )
			
			local attacker = event.attacker
			
			if attacker and attacker ~= parent and attacker:IsAlive() then
				local mod = attacker:FindModifierByName( "modifier_souls_int" )
				
				if not mod then
					mod = attacker:AddNewModifier( attacker, nil, "modifier_souls_int", {} )
				end
				
				mod:SetStackCount( mod:GetStackCount() + lostSouls + 1 )
			
				local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf", PATTACH_ABSORIGIN, attacker )
				
				ParticleManager:SetParticleControl( part, 0, parent:GetAbsOrigin() )
				ParticleManager:SetParticleControlEnt( part, 1, attacker, PATTACH_ABSORIGIN, "", attacker:GetAbsOrigin(), true )
				
				ParticleManager:ReleaseParticleIndex( part )
			end
		end
	end
end