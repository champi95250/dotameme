modifier_attack_spells = class({})

--------------------------------------------------------------------------------

function modifier_attack_spells:IsHidden()
	return true
end

function modifier_attack_spells:IsDebuff()
	return false
end

function modifier_attack_spells:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_attack_spells:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ATTACK,
		}
	 
		return funcs
	end

--------------------------------------------------------------------------------

	function modifier_attack_spells:OnAttack( event )
		local parent = self:GetParent()
		
		if event.target.GetContainedItem then
			return
		end
		
		local chance = RandomInt(1, 10) 
		
		if chance == 1 then
		
			if event.attacker == parent and parent:HasAnyActiveAbilities() and not parent:IsIllusion() then
				if not event.target:IsAlive() then
					return
				end
				print("cast")
				
				local loc = event.target:GetAbsOrigin()
				
				--local exception_table = {}
				--table.insert(exception_table, "guimauve_skewer")
				--table.insert(exception_table, "pedobear_kidnap")
				
				local spellList = {}
				
				for i = 0, 15 do
					local spell = parent:GetAbilityByIndex( i )
					
					if spell and not spell:IsPassive() and not spell:IsToggle() and spell:GetLevel() > 0 then
						table.insert( spellList, spell )
					end
				end
				
				local spellCast = spellList[RandomInt( 1, #spellList )]
				
				if spellCast then
					if bit.band( spellCast:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) > 0 then
						parent:SetCursorCastTarget( parent )
						parent:SetCursorPosition( parent:GetAbsOrigin() )
					else
						parent:SetCursorCastTarget( event.target )
						parent:SetCursorPosition( event.target:GetAbsOrigin() )
					end
					
					spellCast:OnSpellStart()
				end
			end
		
		end
	end
end