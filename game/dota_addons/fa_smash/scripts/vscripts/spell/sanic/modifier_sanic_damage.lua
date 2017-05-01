modifier_sanic_damage = class({})

function modifier_sanic_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_sanic_damage:OnCreated()
	-- Variables
	local ability = self:GetAbility()
	local caster = self:GetParent()
	self.prc_movespeed = ability:GetSpecialValueFor( "prc_damage" )
	
	if caster:HasAbility("sanic_hegehog") and caster:HasModifier("modifier_sprint_sanic_ulti") then
		local sanic_hegehog = caster:FindAbilityByName("sanic_hegehog")
		if sanic_hegehog:GetLevel() == 1 then
			print("HEGE LVL1")
			self.prc_movespeed = self.prc_movespeed * 1.75 
		elseif sanic_hegehog:GetLevel() == 2 then
			print("HEGE LVL2")
			self.prc_movespeed = self.prc_movespeed * 2 
		elseif sanic_hegehog:GetLevel() == 3 then
			print("HEGE LVL3")
			self.prc_movespeed = self.prc_movespeed * 2.25 
		end
	end
	
	if caster:HasAbility("sanic_go_fast") and caster:HasModifier("modifier_sanic_go_fast") then
		local sanic_go_fast = caster:FindAbilityByName("sanic_go_fast")
		if sanic_go_fast:GetLevel() == 1 then
			self.prc_movespeed = self.prc_movespeed * 1.1 
			print("FAST LVL1")
		elseif sanic_go_fast:GetLevel() == 2 then
			self.prc_movespeed = self.prc_movespeed * 1.3
			print("FAST LVL2")
		elseif sanic_go_fast:GetLevel() == 3 then
			self.prc_movespeed = self.prc_movespeed * 1.5 
			print("FAST LVL3")
		elseif sanic_go_fast:GetLevel() == 4 then
			self.prc_movespeed = self.prc_movespeed * 1.7
			print("FAST LVL4")
		end
	end
	
	self.vitesse_prc = caster:GetBaseMoveSpeed() * self.prc_movespeed / 100
	print("DAMAGE :" .. self.vitesse_prc)
    if IsServer() then
    end
end


function modifier_sanic_damage:GetModifierBaseAttack_BonusDamage( params )
    return self.vitesse_prc
end

function modifier_sanic_damage:IsHidden()
    return true
end
