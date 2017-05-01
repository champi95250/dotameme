spike_bomb = class({})
LinkLuaModifier( "modifier_spike_bomb_lua","spell/traps/modifier_spike_bomb_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spike_bomb_thinker_lua","spell/traps/modifier_spike_bomb_thinker_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spike_bomb:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------

function spike_bomb:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_spike_bomb_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




