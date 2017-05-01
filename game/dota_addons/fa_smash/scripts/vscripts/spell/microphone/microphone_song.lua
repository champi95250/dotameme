LinkLuaModifier("modifier_voodoo_lua", "spell/microphone/modifier_voodoo_lua.lua", LUA_MODIFIER_MOTION_NONE)

-- local ability = event.ability   -- ability.song = 1 2 3 4 

function StartSinging( event )
	local caster = event.caster
	local ability = event.ability
	local this_abilityLevel = ability:GetLevel()
	print(this_abilityLevel)
	ability.random_abi = RandomInt(1, this_abilityLevel) -- 1 2 3 4
	-- ability.song = random(1,4)

	-- Swap sub_ability
	local sub_ability_name = event.sub_ability_name
	local main_ability_name = ability:GetAbilityName()

	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )

	-- Make cooldown
	sub_ability = caster:FindAbilityByName( sub_ability_name )
	local cooldown = sub_ability:GetCooldown( sub_ability:GetLevel() - 1 )

	sub_ability:EndCooldown()
	sub_ability:StartCooldown( cooldown )

	-- Play the song, which will be stopped when the sub ability fires
	if ability.random_abi == 1 then
		caster:EmitSound( "Microphone.russe_song" )
		sub_ability:EndCooldown()
		sub_ability:StartCooldown( 3.5 )
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_of_the_siren_caster_datadriven", {duration = 16})
		Timers:CreateTimer(3,function()
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_russe_song_aura", {duration = 13})
		end)
	elseif ability.random_abi == 2 then
		caster:EmitSound( "Microphone.im_a_sheep" )
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_of_the_siren_caster_datadriven", {duration = 15})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_sheep_aura", {duration = 15})
	elseif ability.random_abi == 3 then
		caster:EmitSound( "Microphone.dingdong" )
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_of_the_siren_caster_datadriven", {duration = 15})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_song_dingdong_aura", {duration = 15})
	end
end


--[[
	Author: Ractidous
	Date: 25.01.2015.
	Stops the sound and swaps the abilities back to the original state.
]]
function CancelSinging( event )
	local caster = event.caster
	local ability = event.ability

	-- Stops the song
	if ability.random_abi == 1 then
		caster:StopSound( "Microphone.russe_song" )
		caster:RemoveModifierByName("modifier_song_russe_song_aura") 
	elseif ability.random_abi == 2 then
		caster:StopSound( "Microphone.im_a_sheep" )
		caster:RemoveModifierByName("modifier_song_sheep_aura") 
	elseif ability.random_abi == 3 then
		caster:StopSound( "Microphone.dingdong" )
		caster:RemoveModifierByName("modifier_song_dingdong_aura") 
	end
	
	-- Plays the cancel sound
	caster:EmitSound( "Hero_NagaSiren.SongOfTheSiren.Cancel" )
end


--[[
	Author: Ractidous
	Date: 25.01.2015.
	Swap the abilities back to the original state.
]]
function EndSinging( event )
	local caster = event.caster
	local ability = event.ability

	-- Swap the sub_ability back to normal
	local main_ability_name = ability:GetAbilityName()
	local sub_ability_name = event.sub_ability_name

	caster:SwapAbilities( main_ability_name, sub_ability_name, true, false )
	
	if ability.random_abi == 1 then
		caster:StopSound( "Microphone.russe_song" )
		caster:RemoveModifierByName("modifier_song_russe_song_aura") 
	elseif ability.random_abi == 2 then
		caster:StopSound( "Microphone.im_a_sheep" )
		caster:RemoveModifierByName("modifier_song_sheep_aura") 
	elseif ability.random_abi == 3 then
		caster:StopSound( "Microphone.dingdong" )
		caster:RemoveModifierByName("modifier_song_dingdong_aura") 
	end
end


--[[
	Author: Noya
	Date: 16.01.2015.
	Levels up the ability_name to the same level of the ability that runs this
]]
function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = "microphone_song_complete_stop"
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end



function voodoo_start( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	
	target:AddNewModifier(caster, ability, "modifier_voodoo_lua", {duration = 1.5})
end

function BerserkersCall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function BerserkersCallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end