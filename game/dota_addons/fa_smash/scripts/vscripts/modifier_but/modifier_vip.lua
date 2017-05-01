function VIP(keys)
local caster = keys.caster
	for i = 1, #vip_members do
		if PlayerResource:GetSteamAccountID(caster:GetPlayerID()) == vip_members[i] then
			local vip_effect2 = ParticleManager:CreateParticle("particles/vip/vip_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(vip_effect2, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(vip_effect2, 1, caster:GetAbsOrigin())
		end
	end
end