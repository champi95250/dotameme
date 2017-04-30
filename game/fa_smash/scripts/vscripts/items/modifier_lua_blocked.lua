function modifier_lua_blocked:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_REFLECT_SPELL, --Lotus Orb trigger.
        MODIFIER_PROPERTY_ABSORB_SPELL --Linken's Sphere trigger.
    }
    return funcs
end

function modifier_lua_blocked:GetReflectSpell(keys)
	if self.stored ~= nil then
		self.stored:RemoveSelf() --we make sure to remove previous spell.
    end
    local hCaster = self:GetParent()
    local hAbility = hCaster:AddAbility(kv.ability:GetAbilityName())
    hAbility:SetStolen(true) --just to be safe with some interactions.
    hAbility:SetHidden(true) --hide the ability.
    hAbility:SetLevel(kv.ability:GetLevel()) --same level of ability as the origin.
    hCaster:SetCursorCastTarget(kv.ability:GetCaster()) --lets send this spell back.
    hAbility:OnSpellStart() --cast the spell.
    self.stored = hAbility --store the spell reference for future use.
end

function modifier_lua_blocked:GetAbsorbSpell(keys)
  local hAbility = self:GetAbility()
    if hAbility:IsCooldownReady() then
    --your cool effect here.
    hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel()))
    return 1
    end
    return false
end