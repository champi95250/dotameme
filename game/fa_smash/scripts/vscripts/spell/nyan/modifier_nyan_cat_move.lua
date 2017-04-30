modifier_nyan_cat_move = class({})

function modifier_nyan_cat_move:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }

    return funcs
end

function modifier_nyan_cat_move:OnCreated()
	-- Variables
	local ability = self:GetAbility()
	self.nyan_cat_movement = ability:GetSpecialValueFor( "movement_speed" )
    if IsServer() then
    end
end

function modifier_nyan_cat_move:GetModifierMoveSpeed_Absolute( params )
    return self.nyan_cat_movement
end

function modifier_nyan_cat_move:GetModifierMoveSpeed_Max( params )
    return self.nyan_cat_movement
end

function modifier_nyan_cat_move:GetModifierMoveSpeed_Limit( params )
    return self.nyan_cat_movement
end

function modifier_nyan_cat_move:IsHidden()
    return true
end