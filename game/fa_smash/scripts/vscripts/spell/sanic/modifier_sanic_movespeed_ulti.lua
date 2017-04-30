modifier_sanic_movespeed_ulti = class({})

function modifier_sanic_movespeed_ulti:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_sanic_movespeed_ulti:GetModifierMoveSpeed_Max( params )
    return 2500
end

function modifier_sanic_movespeed_ulti:GetModifierMoveSpeed_Limit( params )
    return 2500
end

function modifier_sanic_movespeed_ulti:IsHidden()
    return true
end