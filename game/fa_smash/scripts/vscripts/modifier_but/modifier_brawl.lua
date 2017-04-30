LinkLuaModifier("modifier_brawl_stun","modifier_but/modifier_brawl.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brawl_air","modifier_but/modifier_brawl.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brawl_root","modifier_but/modifier_brawl.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brawl_min_health","modifier_but/modifier_brawl.lua",LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------------------------------
--    Modifier: modifier_brawl        
--------------------------------------------------------------------------------------------------------
if modifier_brawl ~= "" then modifier_brawl = class({}) end
----------------------------------------------------------------------------------------------------------
function modifier_brawl:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
end
----------------------------------------------------------------------------------------------------------
function modifier_brawl:IsHidden()
  return true
end
----------------------------------------------------------------------------------------------------------
if IsServer() then
----------------------------------------------------------------------------------------------------------
function modifier_brawl:OnCreated()
  return true
end
----------------------------------------------------------------------------------------------------------
function modifier_brawl:OnTakeDamage(keys)
  local unit = keys.unit
  local attacker = keys.attacker
  local ability = keys.inflictor

  if unit and attacker and (unit ~= attacker or keys.damage > 70) and not unit:IsNull() and not attacker:IsNull() and not unit:IsBuilding() then
    if not unit:IsRooted() or unit:HasModifier("modifier_brawl_root") then
      local vFrom = keys.attacker:GetAbsOrigin() + keys.attacker:GetForwardVector() * 32
      local vSelf = keys.unit:GetAbsOrigin()
      local vDiff = vSelf - vFrom
      local vDiffReverse = vFrom - vSelf

      local unitHPDefecit = unit:GetHealthDeficit()
      local unitHPModifier = unitHPDefecit * 0.4
      local unitWeightModifier = 500 / (250 + unit:GetMaxHealth())

      local knockbackMultiplier = 1
      local knockbackBaseValue = 300
      local knockbackRatio = 1

      if ability then
        if not ability:IsNull() and ability:HasKnockbackMultiplier() then
          knockbackMultiplier = ability:GetKnockbackMultiplier()
        end
        if not ability:IsNull() and ability:HasBaseKnockbackValue() then
          knockbackBaseValue = ability:GetBaseKnockbackValue() 
        end
      else
        if attacker:IsRangedAttacker() then
          knockbackMultiplier = knockbackMultiplier * 0.8
        end
        if attacker:IsIllusion() then
          knockbackMultiplier = knockbackMultiplier * 0.5
        end
      end

      local vPower = ((((((unitHPModifier)/10 + (unitHPModifier * keys.damage)/20 ) * unitWeightModifier * 1.4) + 18) * knockbackMultiplier) + knockbackBaseValue ) * knockbackRatio
      local vVelo = vDiff:Normalized() * vPower
      local vDistance = vDiff:Length()

      local vPowerAbs = math.abs(vPower)

      unit:StartPhysicsSimulation ()
      unit:SetPhysicsFriction(0.05 * (1000/vPowerAbs))
      unit:AddPhysicsVelocity(vVelo)
      unit.flip = -(vPowerAbs/100)^1.1 - 5
      unit.lastAttacker = attacker

      if vPowerAbs > 500 then
        unit:SetPhysicsAcceleration(Vector(0,0,0))
        unit:SetForwardVector(vDiffReverse:Normalized())
        unit:RemoveModifierByName("modifier_brawl_stun")
        local stunDuration = (vPowerAbs/5000)^0.5 * (100 - unit:GetHealthPercent())/40 + 0.1
        unit:AddNewModifier(attacker,nil,"modifier_brawl_stun",{Duration = stunDuration})
        unit:AddNewModifier(attacker,nil,"modifier_brawl_root",{})
        unit:AddPhysicsVelocity(Vector(0,0,vPowerAbs))
        ScreenShake(vSelf, (vPowerAbs/1500)^2, (vPowerAbs/1000)^2, stunDuration^0.5, vPowerAbs, 0, true)
        unit.isLaunching = true
      else
        unit:AddNewModifier(attacker,nil,"modifier_brawl_air",{Duration = vPowerAbs/1000})
      end

      
      


      if not unit:IsAlive() then
        local flip = unit.flip / 3
        Timers:CreateTimer(0.03, function()
          if unit:IsNull() then return nil end
          if unit.isLaunching == true then
            unit:SetAngles(unit:GetAngles().x + flip,unit:GetAngles().y,unit:GetAngles().z)
            return 0.03
          else
            return nil
          end
        end)
        Timers:CreateTimer(0.5, function()
          if unit:IsNull() then return nil end
          unit:AddPhysicsAcceleration(Vector(0,0,-30))
          if unit:GetAbsOrigin().z <= GetGroundPosition(unit:GetAbsOrigin(),unit).z + 128 then
            unit:SetPhysicsAcceleration(Vector(0,0,0))
            unit:SetAngles(0,unit:GetAngles().y,unit:GetAngles().z)
            unit:StopPhysicsSimulation()
            FindClearSpaceForUnit(unit,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,0),false)
            unit.isLaunching = false
            return nil
          else
            return 0.03
          end
        end)
      end
    end
  end
end
----------------------------------------------------------------------------------------------------------
end
-------------------------------------------------------------------------------------------------------
--    Modifier: modifier_brawl_stun       
--------------------------------------------------------------------------------------------------------
if modifier_brawl_stun ~= "" then modifier_brawl_stun = class({}) end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:IsHidden()
  return true
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:RemoveOnDeath()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:IsPurgable()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:CheckState()
  return {
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
  }
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:DeclareFunctions()
  return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:GetOverrideAnimation()
  return ACT_DOTA_FLAIL
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:GetEffectName()
  return "particles/units/heroes/hero_centaur/centaur_stampede.vpcf"
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_stun:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
-------------------------------------------------------------------------------------------------------
--    Modifier: modifier_brawl_air      
--------------------------------------------------------------------------------------------------------
if modifier_brawl_air ~= "" then modifier_brawl_air = class({}) end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_air:IsHidden()
  return true
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_air:RemoveOnDeath()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_air:IsPurgable()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_air:OnDestroy()
  local unit = self:GetParent()
  if unit then 
    FindClearSpaceForUnit(unit,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,0),false)
  end
  return true
end
-------------------------------------------------------------------------------------------------------
--    Modifier: modifier_brawl_root      
--------------------------------------------------------------------------------------------------------
if modifier_brawl_root ~= "" then modifier_brawl_root = class({}) end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_root:IsHidden()
  return true
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_root:RemoveOnDeath()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_root:IsPurgable()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_root:CheckState()
  return {
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }
end
---------------------------------------------------------------------------------------------------------
if IsServer() then
---------------------------------------------------------------------------------------------------------
function modifier_brawl_root:OnCreated()
  self:StartIntervalThink(0.03)
end
----------------------------------------------------------------------------------------------------------
function modifier_brawl_root:OnIntervalThink()
  local unit = self:GetParent()
  if not unit then return end

  local unitPos = unit:GetAbsOrigin()
  local flip = unit.flip or -10

  GridNav:DestroyTreesAroundPoint(unitPos,200,false)

  if unit.isLaunching == true then
    unit:SetAngles(unit:GetAngles().x + flip,unit:GetAngles().y,unit:GetAngles().z)
  end

  if not unit:HasModifier("modifier_brawl_air") and not unit:HasModifier("modifier_brawl_stun") then

    if unit.isLaunching == true then
      unit:SetFriction(0.05)
      unit:SetAngles(0,0,0)
      unit.isLaunching = false
    end

    unit:AddPhysicsAcceleration(Vector(0,0,-175))

    if unitPos.z <= GetGroundPosition(unitPos,unit).z + 128 then
      unit:SetPhysicsVelocity(Vector(0,0,0))
      unit:SetPhysicsAcceleration(Vector(0,0,0))
      unit:StopPhysicsSimulation()
      FindClearSpaceForUnit(unit,Vector(unitPos.x,unitPos.y,0),false)
      unit:RemoveModifierByName("modifier_brawl_root")
      unit:SetAngles(0,unit:GetAngles().y,unit:GetAngles().z)
      return nil
    end
  else
    if unitPos.z <= GetGroundPosition(unitPos,unit).z then
      unit:SetPhysicsVelocity(Vector(unit:GetPhysicsVelocity().x,unit:GetPhysicsVelocity().y,math.abs(unit:GetPhysicsVelocity().z)))
      return nil
    end
  end

  if unit and unitPos.z > 2500 and unit:IsAlive() then
    unit:SetPhysicsVelocity(Vector(0,0,0))
    unit:SetPhysicsAcceleration(Vector(0,0,-30))
    unit:EmitSound("Hero_Invoker.SunStrike.Ignite")
    local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf",PATTACH_WORLDORIGIN,unit)
    ParticleManager:SetParticleControl(particle, 0, GetGroundPosition(unitPos,unit))
    ScreenShake(GetGroundPosition(unitPos,unit), 5000, 500, 0.8, 2400, 0, true)
    unit:Kill(nil, unit.lastAttacker)
    return nil
    --unit:ForceKill(false)
  end
end
---------------------------------------------------------------------------------------------------------
end
-------------------------------------------------------------------------------------------------------
--    Modifier: modifier_brawl_min_health        
--------------------------------------------------------------------------------------------------------
if modifier_brawl_min_health ~= "" then modifier_brawl_min_health = class({}) end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_min_health:IsHidden()
  return true
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_min_health:RemoveOnDeath()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_min_health:IsPurgable()
  return false
end
---------------------------------------------------------------------------------------------------------
function modifier_brawl_min_health:DeclareFunctions()
  return { 
    MODIFIER_PROPERTY_MIN_HEALTH
  }
end
----------------------------------------------------------------------------------------------------------
function modifier_brawl_min_health:GetMinHealth()
  return 1
end
---------------------------------------------------------------------------------------------------------