modifier_sanic_movespeed = class({})

function modifier_sanic_movespeed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_sanic_movespeed:OnCreated()
	-- Variables
	local ability = self:GetAbility()
	self.prc_movespeed = ability:GetSpecialValueFor( "prc_move" )
	self.limit = ability:GetSpecialValueFor( "limitation" )
    if IsServer() then
    end
end

function modifier_sanic_movespeed:GetModifierMoveSpeedBonus_Percentage( params )
    return self.prc_movespeed
end

function modifier_sanic_movespeed:IsPurgable()
	return false
end

function modifier_sanic_movespeed:GetModifierMoveSpeed_Max( params )
    return self.limit
end

function modifier_sanic_movespeed:GetModifierMoveSpeed_Limit( params )
    return self.limit
end

function modifier_sanic_movespeed:IsHidden()
    return true
end