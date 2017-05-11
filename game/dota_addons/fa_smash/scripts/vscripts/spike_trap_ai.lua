local triggerActive = true
local PedoActive = true

function Fire(trigger)
local triggerName = thisEntity:GetName()
local activator = trigger.activator
local target = Entities:FindByName( nil, triggerName .. "_target" ) -- npc_dota_spike_trap_cp2_target
local spikes = triggerName .. "_model" -- npc_dota_spike_trap_cp2_model Le model
local dust = triggerName .. "_particle" -- lance une autre particle
local fx = triggerName .. "_fx" -- npc_dota_spike_trap_cp2_fx Dans le model , lance la particle
local random_abi = RandomInt(1, 8)
print("Activator: "..activator:GetName())
print("Trap Number: "..random_abi)

	if target ~= nil and triggerActive == true then
		EmitSoundOn("ui.replay_dn_start", spikeTrap)
		if random_abi == 1 then
			BombTrap(activator, target)
		elseif random_abi == 2 then
			GoldTrap(activator, target)
		elseif random_abi == 3 then
			Timers:CreateTimer(1.0, function()
				local spikeTrap_explosion = thisEntity:FindAbilityByName("spike_explosion")
				thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_explosion, -1 )
			end)
		elseif random_abi == 4 then
			EmitSoundOn("Hero_Enigma.Black_Hole.Stop", target)
			Timers:CreateTimer(1.0, function()
				local spikeTrap_black = thisEntity:FindAbilityByName("black_hole_datadriven")
				thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_black, -1 )
			end)
		elseif random_abi == 5 then
			local spikeTrap_torrent = thisEntity:FindAbilityByName("torrent_datadriven")
			thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_torrent, -1 )
		elseif random_abi == 6 then
			HealingTrap(activator)
		elseif random_abi == 7 or random_abi == 8 then
			DoorTrap(target)
		end

		DoEntFire( spikes, "SetAnimation", "traps_active", 0, self, self )
		DoEntFire( dust, "Start", "", 0, self, self )
		DoEntFire( dust, "Stop", "", 2, self, self )
		DoEntFire( fx, "Start", "", 0, self, self )
		DoEntFire( fx, "Stop", "", 2, self, self )
		
		--thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel( spikes ) end, 3 )
		triggerActive = false
		DoEntFire( spikes, "SetAnimation", "traps_desactive", 15, self, self )
		thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel() end, 15 )
	end
end

function ResetTrapModel()
	triggerActive = true
	PedoActive = true
end

function BombTrap(activator, target)
	Timers:CreateTimer(7.6, function()
		local enemies = FindUnitsInRadius(activator:GetTeamNumber(), Vector(0, 0, 0), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = activator, damage = 9999, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end)
	EmitSoundOn("Mlg.bombe", target)
end

function GoldTrap(activator, target)
	Timers:CreateTimer(1.0, function()
		Notifications:Bottom(activator:GetPlayerOwnerID(), {text="+500 gold!", duration=5.0, style={color="yellow"}})
		PlayerResource:ModifyGold(activator:GetPlayerOwnerID(), 500, false, DOTA_ModifyGold_Unspecified)
		EmitSoundOn("Mlg.gold", target)
	end)
end

function DoorTrap(target)
local DoorTraps = 0

	if DoorTraps == 0 then
		Timers:CreateTimer(1.0, function()
			DoorTraps = 1
			EmitSoundOn("BOTM.GateTrap.Interact", target)
			for i = 1, 4 do
				local DoorObs = Entities:FindAllByName("obstruction_mid"..i)
				for _, obs in pairs(DoorObs) do
					obs:SetEnabled(true, false)
				end
				DoEntFire("door_mid"..i, "SetAnimation", "gate_entrance002_close", 0, nil, nil)
			end
			Timers:CreateTimer(10.0,function()
				for i = 1, 4 do
					local DoorObs = Entities:FindAllByName("obstruction_mid"..i)
					for _, obs in pairs(DoorObs) do
						obs:SetEnabled(false, true)
					end
					DoEntFire("door_mid"..i, "SetAnimation", "gate_entrance002_open", 0, nil, nil)
				end
				DoorTraps = 0
				EmitSoundOn("BOTM.GateTrap.Interact", target)
			end)
		end)
	end
end

function HealingTrap(activator)
local health_pct = activator:GetMaxHealth()/100
local value = 0.0

	Timers:CreateTimer(1.0, function()
		Notifications:Bottom(activator:GetPlayerOwnerID(), {text="Healing!", duration=5.0, style={color="green"}})
		EmitSoundOn("Mlg.jokoloaz", target)
		Timers:CreateTimer(0.1, function()
			value = value + 0.1
			activator:Heal(health_pct, activator)
			if value < 3.0 then
			else return nil
			end
			return 0.1
		end)
	end)
end