modifier_runee_invis = class({})
LinkLuaModifier("modifier_modifier_runee_invis_fade", "runes/modifier_runee_invis.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_modifier_runee_invis", "runes/modifier_runee_invis.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_runee_invis:OnUpgrade()
	 if IsServer() then
		 local caster = self:GetCaster()
		 local ability = self	 
		 local buff = "modifier_modifier_runee_invis_fade"
		 local fade_time = 0.5
		 print("OK:" .. ability)
		 
		 if not caster:HasModifier(buff) then
			caster:AddNewModifier(caster, ability, buff, {duration = fade_time})
		 end
	end
end



--invisibility fade buff
modifier_modifier_runee_invis_fade = class({})

function modifier_modifier_runee_invis_fade:IsDebuff()
	return false	
end

function modifier_modifier_runee_invis_fade:IsHidden()
	return false	
end

function modifier_modifier_runee_invis_fade:IsPurgable()
	return false	
end

function modifier_modifier_runee_invis_fade:OnCreated()
	if IsServer() then
		self.caster = self:GetParent()
		self.ability = self:GetAbility()
	end
end

function modifier_modifier_runee_invis_fade:OnDestroy()
	if IsServer() then
		local caster = self.caster
		local ability = self.ability
		local invis_buff = "modifier_modifier_runee_invis"	
		print(ability)	
	
		caster:AddNewModifier(caster, ability, invis_buff, {duration = 25})
		caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = 25})
	end
end

function modifier_modifier_runee_invis_fade:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FINISHED}
		
		return decFuncs	
end

function modifier_modifier_runee_invis_fade:OnAttackFinished( keys )
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	if caster == keys.attacker then			

		--caster:RemoveModifierByName("modifier_modifier_runee_invis_fade")
		--caster:RemoveModifierByName("modifier_invisible")
		--caster:RemoveModifierByName("modifier_modifier_runee_invis")
		--caster:AddNewModifier(caster, ability, invis_fade, {duration = fade_time})
		self:Destroy()
	end
end

--actual invisibility buff
modifier_modifier_runee_invis = class({})

function modifier_modifier_runee_invis:IsDebuff()
	return false	
end

function modifier_modifier_runee_invis:IsHidden()
	return false	
end

function modifier_modifier_runee_invis:IsPurgable()
	return false	
end

function modifier_modifier_runee_invis:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FINISHED}
		
		return decFuncs	
end

function modifier_modifier_runee_invis:OnAttackFinished( keys )
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()	
		
		if caster == keys.attacker then
			
			caster:RemoveModifierByName("modifier_invisible")
			--caster:AddNewModifier(caster, ability, invis_fade, {duration = fade_time})
			self:Destroy()
		end
	end
end