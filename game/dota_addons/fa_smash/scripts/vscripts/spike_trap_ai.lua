local triggerActive = true
local PedoActive = true
local jihabbomb_active = false

function Fire(trigger)

	-- List Spell : Door, Torrent, Slip/healing, Repel, Jihad Bomb. ( Surprise Activator )

	local triggerName = thisEntity:GetName() -- npc_dota_spike_trap_cp3
	local activator = trigger.activator
	local target = Entities:FindByName( nil, triggerName .. "_target" ) -- npc_dota_spike_trap_cp2_target
	local spikes = triggerName .. "_model" -- npc_dota_spike_trap_cp2_model Le model
	local dust = triggerName .. "_particle" -- lance une autre particle
	local fx = triggerName .. "_fx" -- npc_dota_spike_trap_cp2_fx Dans le model , lance la particle
	local random_abi = RandomInt(1, 6)
	print("Activator: "..activator:GetName())
	print("Trap Number: "..random_abi)

	if target ~= nil and triggerActive == true then
		EmitSoundOn("ui.replay_dn_start", spikeTrap)
		if random_abi == 1 then -- Door
			DoorTrap(target)
		elseif random_abi == 2 then -- Torrent
			local spikeTrap_torrent = thisEntity:FindAbilityByName("torrent_datadriven")
			thisEntity:CastAbilityOnPosition(Vector(0, 0, 75), spikeTrap_torrent, -1 )
		elseif random_abi == 3 then -- Slip/healing
			HealingTrap(activator)
		elseif random_abi == 4 then -- Repel is Torrent provisoire
			local spikeTrap_torrent = thisEntity:FindAbilityByName("torrent_datadriven")
			thisEntity:CastAbilityOnPosition(Vector(0, 0, 75), spikeTrap_torrent, -1 )
		elseif random_abi == 5 and jihabbomb_active == false then -- Jihad Bomb
			BombTrap(activator, target)
			jihabbomb_active = true
		elseif random_abi == 6 then -- Surprise Activator
			BombTrap(activator, target)
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

function Fire_exterieure(trigger)

	-- List Spell : Door, Black Hole, Force staff, Block Ennemie, Golden Shower, Binling Light ( Surprise Activator ) 

	local triggerName = thisEntity:GetName() -- npc_dota_spike_trap_cp3
	local activator = trigger.activator
	local target = Entities:FindByName( nil, triggerName .. "_target" ) -- npc_dota_spike_trap_cp2_target
	local spikes = triggerName .. "_model" -- npc_dota_spike_trap_cp2_model Le model
	local dust = triggerName .. "_particle" -- lance une autre particle
	local fx = triggerName .. "_fx" -- npc_dota_spike_trap_cp2_fx Dans le model , lance la particle
	local random_abi = RandomInt(1, 6)
	print("Activator: "..activator:GetName())
	print("Trap Number: "..random_abi)

	if target ~= nil and triggerActive == true then
		EmitSoundOn("ui.replay_dn_start", spikeTrap)
		if random_abi == 1 then -- Door
			DoorTrap(target)
		elseif random_abi == 2 then -- Black Hole
			EmitSoundOn("Hero_Enigma.Black_Hole.Stop", target)
			Timers:CreateTimer(1.0, function()
				local spikeTrap_black = thisEntity:FindAbilityByName("black_hole_datadriven")
				thisEntity:CastAbilityOnPosition(Vector(0, 0, 350), spikeTrap_black, -1 )
			end)
		elseif random_abi == 3 then -- Force staff ... Black Hole provisoire
			EmitSoundOn("Hero_Enigma.Black_Hole.Stop", target)
			Timers:CreateTimer(1.0, function()
				local spikeTrap_black = thisEntity:FindAbilityByName("black_hole_datadriven")
				thisEntity:CastAbilityOnPosition(Vector(0, 0, 350), spikeTrap_black, -1 )
			end)
		elseif random_abi == 4 then -- Block Ennemie
			DoorTrapInter(target)
		elseif random_abi == 5 then -- Golden Shower
			GameMode:SpawnGold()
			GameMode:SpawnGold()
			GameMode:SpawnGold()
			GameMode:SpawnGold()
			GameMode:SpawnGold()
		elseif random_abi == 6 then -- Binling Light
			Timers:CreateTimer(1.0, function()
				local spikeTrap_light = thisEntity:FindAbilityByName("spike_explosion")
				thisEntity:CastAbilityOnPosition(Vector(0, 0, 175), spikeTrap_light, -1 )
			end)
		elseif random_abi == 7 then -- Surprise Activator
			BombTrap(activator, target)
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

	local number = 8.0
	local center = Vector( 0, 100, 0)
	local dummy = CreateUnitByName( "npc_dummy_unit_advance", center, false, target, target, target:GetTeamNumber() )
	EmitSoundOn("Mlg.bombe", dummy)

	Timers:CreateTimer(0.4, function()
		local particleName = "particles/trap/counter.vpcf"
		local preSymbol = 0 -- Empty
		local digits = 2 -- "5.0" takes 2 digits
		number = number - 0.5
		local integer = math.floor(math.abs(number))
		local decimal = math.abs(number) % 1

		if decimal < 0.5 then 
			decimal = 1 -- ".0"
		else 
			decimal = 8 -- ".5"
		end

		print(integer,decimal)

		if integer == 0 and decimal == 1 then
		  	return false		
		else

			local particle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, dummy)	
			ParticleManager:SetParticleControl( particle, 0, Vector( 0, 100, 0) )
			ParticleManager:SetParticleControl( particle, 1, Vector( preSymbol, integer, decimal) )
			ParticleManager:SetParticleControl( particle, 2, Vector( digits, 0, 0) )
		end
		return 0.5
	end)


	Timers:CreateTimer(7.6, function()
		local enemies = FindUnitsInRadius(activator:GetTeamNumber(), Vector(0, 0, 0), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = activator, damage = 99999, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end)
	
end

function GoldTrap(activator, target)
	Timers:CreateTimer(1.0, function()
		Notifications:Bottom(activator:GetPlayerOwnerID(), {text="+500 gold!", duration=5.0, style={color="yellow"}})
		PlayerResource:ModifyGold(activator:GetPlayerOwnerID(), 500, false, DOTA_ModifyGold_Unspecified)
		EmitSoundOn("Mlg.gold", target)
	end)
end

function DoorTrapInter(target)
	local DoorTrapInters = 0

	if DoorTrapInters == 0 then
		Timers:CreateTimer(1.0, function()
			DoorTrapInters = 1
			EmitSoundOn("BOTM.GateTrap.Interact", target)
			for i = 1, 4 do
				local DoorObs = Entities:FindAllByName("door_trap"..i)
				for _, obs in pairs(DoorObs) do
					obs:SetEnabled(true, false)
				end
				DoEntFire("door_ext"..i, "SetAnimation", "spike_close", 0, nil, nil)
			end
			Timers:CreateTimer(10.0,function()
				for i = 1, 4 do
					local DoorObs = Entities:FindAllByName("door_trap"..i)
					for _, obs in pairs(DoorObs) do
						obs:SetEnabled(false, true)
					end
					DoEntFire("door_ext"..i, "SetAnimation", "spike_open", 0, nil, nil)
				end
				DoorTrapInters = 0
				EmitSoundOn("BOTM.GateTrap.Interact", target)
			end)
		end)
	end
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

function Repel(activator)
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