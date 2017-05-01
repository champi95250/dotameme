modifier_souls_agility = class({})

--------------------------------------------------------------------------------

function modifier_souls_agility:IsHidden()
	return false
end

function modifier_souls_agility:IsDebuff()
	return false
end

function modifier_souls_agility:IsPurgable()
	return false
end

function modifier_souls_agility:RemoveOnDeath()
	return false
end

function modifier_souls_agility:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_souls_agility:GetTexture()
	return "power_mount_agi"
end

--------------------------------------------------------------------------------

function modifier_souls_agility:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_souls_agility:GetModifierBonusStats_Agility( event )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_souls_agility:OnTooltip( event )
	if self:GetParent():IsHero() then
		return 50
	end
	
	return 100
end

--------------------------------------------------------------------------------
	
if IsServer() then
	function modifier_souls_agility:OnDeath( event )
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
				local mod = attacker:FindModifierByName( "modifier_souls_agility" )
				
				if not mod then
					mod = attacker:AddNewModifier( attacker, nil, "modifier_souls_agility", {} )
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