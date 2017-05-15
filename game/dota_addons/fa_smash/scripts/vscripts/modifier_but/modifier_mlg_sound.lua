modifier_mlg_sound = class({})

--------------------------------------------------------------------------------

function modifier_mlg_sound:IsHidden()
	return true
end

function modifier_mlg_sound:IsDebuff()
	return false
end

function modifier_mlg_sound:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_mlg_sound:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_DEATH,
		}
	 
		return funcs
	end

--------------------------------------------------------------------------------

	function modifier_mlg_sound:OnDeath( event )
		local parent = self:GetParent()
		
		if event.unit == parent and not parent:IsIllusion() then
			if parent:IsHero() then
				local random_sound = RandomInt(1, 14) 
				print("Mlg.Kill" .. random_sound)
				EmitGlobalSound("Mlg.Kill" .. random_sound)
				local mlg_fx = ParticleManager:CreateParticle("particles/mlg/rekt.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(mlg_fx, 0, parent:GetAbsOrigin() + Vector(0, 0, 100))
				Timers:CreateTimer(2.7, function()
					ParticleManager:DestroyParticle(mlg_fx, false)
				end)
			else
			end
		end
		
	end
end