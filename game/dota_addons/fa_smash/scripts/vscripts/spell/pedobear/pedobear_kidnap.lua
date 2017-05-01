-- life_stealer_consume_datadriven a supprimé

function infest_check_valid( keys )
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability

    print(target:GetUnitLabel())
    print(target:GetUnitName())

    --check for validity. theres a lot of exceptions, and i'd like a better way to do this.
    --unsure of the formatting as well as it's a long list.
    local enemyexceptionlist = {"spirit_bear", "visage_familiars"}
    local enemyisexception = false
    for _,item in pairs(enemyexceptionlist) do
        if item == target:GetUnitLabel() and target:GetTeamNumber() ~= caster:GetTeamNumber() then
            enemyisexception = true
            break
        end
    end

    if ability.victime == true or target:IsHero() and caster == target or target:IsCourier() or target:IsBoss() or target:IsAncient() or enemyisexception then
        caster:Hold()
    end
end

function infest_start( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
	EmitSoundOn("Pedobear.girl", caster)
	if caster:HasModifier("modifier_mlg_sound") then
		EmitSoundOn("Pedobear.song", caster)
	end

    caster.ability = {}
    caster.ability["damage"] = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1) 
    caster.ability["range"] = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1) 

    caster.host = caster
	caster.victime = target
	ability.victime = true
    caster.removed_spells = {}
    --add the particle
    -- caster.particleid = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit_icon.vpcf", 7, target, caster:GetTeamNumber())


    -- Strong Dispel
    local RemovePositiveBuffs = false
    local RemoveDebuffs = true
    local BuffsCreatedThisFrameOnly = false
    local RemoveStuns = true
    local RemoveExceptions = false
    caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

    -- Hide the hero underground
    caster.victime:SetAbsOrigin(caster.host:GetAbsOrigin() - Vector(0, 0, -160))
	caster.victime:SetForwardVector(Vector(0,0,180))
    -- caster:SwapAbilities("life_stealer_infest_datadriven", "life_stealer_consume_datadriven", false, true) 

    --Timers:CreateTimer(10, function() reset(keys) end)
end

function infest_move_unit( keys )
    local caster = keys.caster
    --Check if the host still exists
    if caster.victime == nil or not caster.victime:IsAlive() then -- CHANGE THIS PLEASE?
    caster.victime:SetAbsOrigin(caster.host:GetAbsOrigin())
    caster.victime:RemoveModifierByName("modifier_infest_hide")
    caster.host:RemoveModifierByName("modifier_infest_buff")
	local vectore = Vector(caster.host.x - 100 , caster.host.y - 100 * math.sin(victim_angle_rad), 0)
	caster.victime:SetForwardVector(vectore)
    -- caster:SwapAbilities("life_stealer_infest_datadriven", "life_stealer_consume_datadriven", true, false) 

    else
        caster.victime:SetAbsOrigin(caster.host:GetAbsOrigin() - Vector(-75, 0, -220))
		caster.victime:SetForwardVector(Vector(0,0,180))
    end
end

function infest_consume(keys)
local caster = keys.caster
local ability = keys.ability
	caster.victime:SetAbsOrigin(caster.host:GetAbsOrigin()- Vector(-40, -40, 0))
    caster.victime:RemoveModifierByName("modifier_infest_hide")
    caster.host:RemoveModifierByName("modifier_infest_buff")
	local vectore = Vector(0, 180, 0)
	caster.victime:SetForwardVector(vectore)
	caster:StopSound("Pedobear.girl")
	caster:StopSound("Pedobear.song")
	ability.victime = false
    -- caster:SwapAbilities("life_stealer_infest_datadriven", "life_stealer_consume_datadriven", true, false) 
end