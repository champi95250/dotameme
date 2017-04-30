--[[ spike_trap_ai.lua ]]
---------------------------------------------------------------------------
-- AI for the Spike Trap
---------------------------------------------------------------------------

local triggerActive = true
local PedoActive = true

function Fire(trigger)
local triggerName = thisEntity:GetName()
local activator = trigger.activator
local level = trigger.activator:GetLevel()
local target = Entities:FindByName( nil, triggerName .. "_target" ) -- npc_dota_spike_trap_cp2_target
local spikes = triggerName .. "_model" -- npc_dota_spike_trap_cp2_model Le model
local dust = triggerName .. "_particle" -- lance une autre particle
local fx = triggerName .. "_fx" -- npc_dota_spike_trap_cp2_fx Dans le model , lance la particle
print(trigger.activator:GetName())

	if target ~= nil and triggerActive == true then
		local random_abi = RandomInt(1, 8) -- 1 2 3 4
		print("Ability :" .. random_abi)
		if random_abi == 1 then
			local spikeTrap_bomb = thisEntity:FindAbilityByName("spike_bomb")
			thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_bomb, -1 )
			EmitSoundOn( "Mlg.bombe" , target)
		elseif random_abi == 2 then
			local spikeTrap_gold = thisEntity:FindAbilityByName("spike_gold")
			thisEntity:CastAbilityOnTarget(activator, spikeTrap_gold, -1)
			Timers:CreateTimer(2,function()
				EmitSoundOn( "Mlg.gold" , target)
			end)
		elseif random_abi == 3 then
			local spikeTrap_explosion = thisEntity:FindAbilityByName("spike_explosion")
			thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_explosion, -1 )
		elseif random_abi == 4 then
			local spikeTrap_black = thisEntity:FindAbilityByName("black_hole_datadriven")
			thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_black, -1 )
		elseif random_abi == 5 then
			local spikeTrap_torrent = thisEntity:FindAbilityByName("torrent_datadriven")
			thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap_torrent, -1 )
		elseif random_abi == 6 then
			local spikeTrap_healing = thisEntity:FindAbilityByName("healing_traps")
			thisEntity:CastAbilityOnTarget(activator, spikeTrap_healing, -1)
			Timers:CreateTimer(1.0,function()
				EmitSoundOn( "Mlg.jokoloaz" , target)
			end)
		elseif random_abi == 7 or random_abi == 8 then
			for i = 1, 4 do
				local DoorObs = Entities:FindAllByName("obstruction_mid"..i)
				for _, obs in pairs(DoorObs) do
					obs:SetEnabled(true, false)
				end
				DoEntFire("door_mid"..i, "SetAnimation", "gate_entrance002_idle", 0, nil, nil)
			end
			Timers:CreateTimer(10.0,function()
				for i = 1, 4 do
					local DoorObs = Entities:FindAllByName("obstruction_mid"..i)
					for _, obs in pairs(DoorObs) do
						obs:SetEnabled(false, true)
					end
					-- If not "door_mid"..i = SetAnimation gate_entrance002_idle then
					DoEntFire("door_mid"..i, "SetAnimation", "gate_entrance002_open", 0, nil, nil)
					-- end
				end
			end)
		end 
		
		EmitSoundOn( "Conquest.SpikeTrap.Plate" , spikeTrap)
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

