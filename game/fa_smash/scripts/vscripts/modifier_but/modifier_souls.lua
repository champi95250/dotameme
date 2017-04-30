modifier_souls = class({})

--------------------------------------------------------------------------------

function modifier_souls:IsHidden()
	return false
end

function modifier_souls:IsDebuff()
	return false
end

function modifier_souls:IsPurgable()
	return false
end

function modifier_souls:RemoveOnDeath()
	return false
end

function modifier_souls:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_souls:GetTexture()
	return "nevermore_necromastery"
end

--------------------------------------------------------------------------------

function modifier_souls:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_souls:GetModifierPreAttack_BonusDamage( event )
	return self:GetStackCount() * 2
end

--------------------------------------------------------------------------------

function modifier_souls:OnTooltip( event )
	if self:GetParent():IsHero() then
		return 50
	end
	
	return 100
end

--------------------------------------------------------------------------------
	
if IsServer() then
	function modifier_souls:OnDeath( event )
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
				local mod = attacker:FindModifierByName( "modifier_souls" )
				
				if not mod then
					mod = attacker:AddNewModifier( attacker, nil, "modifier_souls", {} )
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