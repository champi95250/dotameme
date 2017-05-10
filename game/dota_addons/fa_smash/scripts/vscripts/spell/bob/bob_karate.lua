function LifeBreak( keys )
    -- Variables
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local charge_speed = ability:GetLevelSpecialValueFor("charge_speed", (ability:GetLevel() - 1)) * 1/30
	local cd_agha = ability:GetLevelSpecialValueFor("Costoldown_scepter", (ability:GetLevel() - 1))
	local scepter = HasScepter(caster)

    -- Save modifiernames in ability
    ability.modifiername = keys.ModifierName
    ability.modifiername_debuff = keys.ModifierName_Debuff

    -- Motion Controller Data
    ability.target = target
    ability.velocity = charge_speed
    ability.life_break_z = 0
    ability.initial_distance = (GetGroundPosition(target:GetAbsOrigin(), target)-GetGroundPosition(caster:GetAbsOrigin(), caster)):Length2D()
    ability.traveled = 0
	
	if scepter then
		ability:EndCooldown()
		ability:StartCooldown(cd_agha * GetCooldownReduction(caster))
		print("cd : "..cd_agha * GetCooldownReduction(caster))	
	end
	
	if caster:HasModifier("modifier_mlg_sound") then
		EmitSoundOn("Bob.mlg_karate", caster)
	end
end


function DoDamage(caster, target, ability)
    -- Variables
    local caster_health = caster:GetHealth()
    local target_health = target:GetHealth()
	local scepter = HasScepter(caster)
	local health_damage = 0
	local cd_agha = ability:GetLevelSpecialValueFor("Costoldown_scepter", (ability:GetLevel() - 1))
	
	
    -- local health_cost = ability:GetLevelSpecialValueFor("health_cost_percent", (ability:GetLevel() - 1))
	
	if scepter then
		print("SPECTER")
		health_damage = ability:GetLevelSpecialValueFor("health_damage_scepter", (ability:GetLevel() - 1))
	else
		print("NO SPECTER")
		health_damage = ability:GetLevelSpecialValueFor("health_damage", (ability:GetLevel() - 1))
		
	end
    local dmg_to_target = target_health * health_damage

    -- local dmg_to_caster = caster_health * health_cost
    


    -- Compose the damage tables and apply them to the designated target
    -- ApplyDamage(dmg_table_caster)

    local dmg_table_target = {
                                victim = target,
                                attacker = caster,
                                damage = dmg_to_target,
                                damage_type = DAMAGE_TYPE_MAGICAL
                            }
    ApplyDamage(dmg_table_target)
end

function AutoAttack(caster, target)
        order = 
        {
            UnitIndex = caster:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = target:GetEntityIndex(),
            Queue = true
        }

        ExecuteOrderFromTable(order)
end

function OnMotionDone(caster, target, ability)
    -- Variables
    local modifiername = ability.modifiername
    local modifiername_debuff = ability.modifiername_debuff

    --Remove self modifier
    if caster:FindModifierByName(modifiername) then
        caster:RemoveModifierByName(modifiername)
    end

    -- FireSound
    EmitSoundOn("Bob.karate_coup", target)

    --Particles and effects
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)


    ability:ApplyDataDrivenModifier(caster, target, modifiername_debuff, {})

    DoDamage(caster, target, ability)

    AutoAttack(caster, target)
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function JumpHorizonal( keys )
    -- Variables
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target

    local target_loc = GetGroundPosition(target:GetAbsOrigin(), target)
    local caster_loc = GetGroundPosition(caster:GetAbsOrigin(), caster)
    local direction = (target_loc - caster_loc):Normalized()

    local max_distance = ability:GetLevelSpecialValueFor("max_distance", ability:GetLevel()-1)


    -- Max distance break condition
    if (target_loc - caster_loc):Length2D() >= max_distance then
    	caster:InterruptMotionControllers(true)
    end

    -- Moving the caster closer to the target until it reaches the enemy
    if (target_loc - caster_loc):Length2D() > 100 then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + direction * ability.velocity)
        ability.traveled = ability.traveled + ability.velocity
    else
        caster:InterruptMotionControllers(true)

        -- Move the caster to the ground
        caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))

		OnMotionDone(caster, target, ability)
    end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function JumpVertical( keys )
    -- Variables
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target
    local caster_loc = caster:GetAbsOrigin()
    local caster_loc_ground = GetGroundPosition(caster_loc, caster)

    -- If we happen to be under the ground just pop the caster up
    if caster_loc.z < caster_loc_ground.z then
    	caster:SetAbsOrigin(caster_loc_ground)
    end

    -- For the first half of the distance the unit goes up and for the second half it goes down
    if ability.traveled < ability.initial_distance/2 then
        -- Go up
        -- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
        ability.life_break_z = ability.life_break_z 
        -- Set the new location to the current ground location + the memorized z point
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    elseif caster_loc.z > caster_loc_ground.z then
        -- Go down
        ability.life_break_z = ability.life_break_z 
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    end

end
