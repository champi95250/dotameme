function DamageTarget(keys)
    -- Variables
	local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
    local target_health = target:GetMaxHealth()
    local health_damage = ability:GetLevelSpecialValueFor("prc_life_max_multi", (ability:GetLevel() - 1))
	local pos1 = caster:GetAbsOrigin()

    local dmg_to_target = target_health * health_damage
	
	local knockbackProperties =
    {
        center_x = pos1.x,
        center_y = pos1.y,
        center_z = pos1.z,
        duration = 1.3,
        knockback_duration = 1.3,
        knockback_distance = 0,
        knockback_height = 800
    }

    target:AddNewModifier( target, ability, "modifier_knockback", knockbackProperties )
	
	Timers:CreateTimer(1.3, function()
                 local dmg_table_target = {
                                victim = target,
                                attacker = caster,
                                damage = dmg_to_target,
                                damage_type = DAMAGE_TYPE_PURE
                            }
				ApplyDamage(dmg_table_target)
            end)
    -- Compose the damage tables and apply them to the designated target
   
end